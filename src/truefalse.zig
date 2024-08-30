const std = @import("std");
const system = @import("system.zig");
const File = std.fs.File;

pub fn trueFalse(exit_status: u8) type {
    return struct {
        fn program_name() []const u8 {
            return if (exit_status == 0) "true" else "false";
        }

        const authors = [_][]const u8{"Jim Meyering"};

        fn usage(stdout: File, prog_name: []const u8, status: u8) !void {
            const writer = stdout.writer();
            // zig fmt: off
            const exit_message = if (status == 0)
                 "Exit with a status code indicating success."
            else "Exit with a status code indicating failure.";
            try writer.print(
                "Usage: {s} [ignored command line arguments]\n" ++
                "  or:  {s} OPTION\n" ++
                "{s}\n\n" ++
                "      --help        display this help and exit\n" ++
                "      --version     output version information and exit\n",
                .{ prog_name, prog_name, exit_message });
            // zig fmt: on
            try writer.print(system.usage_builtin_warning, .{program_name()});
            try system.emitAncillaryInfo(stdout, program_name());
        }

        pub fn true_false_main() !void {
            var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
            const args = try std.process.argsAlloc(arena.allocator());
            defer std.process.argsFree(arena.allocator(), args);

            if (args.len == 2) {
                const stdout = std.io.getStdOut();
                defer stdout.close();
                const stderr = std.io.getStdErr();
                defer stderr.close();

                const prog_name = try system.getProgramName(stderr, args[0]);

                if (std.mem.eql(u8, args[1], "--help")) {
                    try usage(stdout, prog_name, 0);
                } else if (std.mem.eql(u8, args[1], "--version")) {
                    try system.version_etc(stdout, program_name(), "GNU coreutils", "v1.0", authors[0..]);
                }
            }

            std.process.exit(exit_status);
        }
    };
}
