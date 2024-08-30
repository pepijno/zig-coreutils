const std = @import("std");
const File = std.fs.File;

pub const usage_builtin_warning = "\n" ++
    "Your shell may have its own version of {s}, which usually supersedes\n" ++
    "the version described here.  Please refer to your shell's documentation\n" ++
    "for details about the option it supports.\n";

pub fn emitAncillaryInfo(stdout: File, program_name: []const u8) !void {
    _ = program_name;
    const writer = stdout.writer();
    try writer.print("\n" ++
        "GNU coreutils online help: <https://www.gnu.org/software/coreutils/>\n" ++
        "Full documentation <https://www.gnu.org/software/coreutils/true>\n" ++
        "or available locally via: info '(coreutils) true invocation'\n", .{});
}

pub fn getProgramName(stderr: File, argv0: ?[]const u8) ![]const u8 {
    if (argv0) |_arg| {
        var arg = _arg;
        const slash = std.mem.lastIndexOfScalar(u8, arg, '/');
        if (slash) |s| {
            if (s >= 6 and std.mem.startsWith(u8, arg[(s - 6)..], "/.libs/")) {
                arg = arg[(s + 1)..];
                if (std.mem.startsWith(u8, arg, "lt-")) {
                    arg = arg[3..];
                    // TODO short name
                }
            }
        }
        // TODO short name
        return arg;
    } else {
        const writer = stderr.writer();
        try writer.print("A NULL argv[0] was passed through an exec system call.\n", .{});
        std.process.abort();
    }
}

pub fn version_etc(stdout: File, program_name: ?[]const u8, package: []const u8, version: []const u8, authors: []const []const u8) !void {
    const writer = stdout.writer();
    if (program_name) |name| {
        try writer.print("{s} ({s}) {s}\n", .{ name, package, version });
    } else {
        try writer.print("{s} {s}\n", .{ package, version });
    }
    // TODO package packager
    try writer.print("Copyright {s} {d} Free Software Foundation, Inc.\n", .{ "(C)", 2024 });
    try writer.print("" ++
        "License GPLv3+: GNU GPL version 3 or later <{s}>.\n" ++
        "This is free software: you are free to change and redistribute it.\n" ++
        "There is NO WARRANTY, to the extent permitted by law.\n\n", .{"https://gnu.org/licenses/gpl.html"});

    switch (authors.len) {
        0 => {},
        1 => {
            try writer.print("Written by {s}.\n", .{authors[0]});
        },
        2 => {
            try writer.print("Written by {s} and {s}.\n", .{ authors[0], authors[1] });
        },
        3 => {
            try writer.print("Written by {s}, {s}, and {s}.\n", .{ authors[0], authors[1], authors[2] });
        },
        4 => {
            try writer.print("Written by {s}, {s}, {s},\nand {s}.\n", .{ authors[0], authors[1], authors[2], authors[3] });
        },
        5 => {
            try writer.print("Written by {s}, {s}, {s},\n{s}, and {s}.\n", .{ authors[0], authors[1], authors[2], authors[3], authors[4] });
        },
        6 => {
            try writer.print("Written by {s}, {s}, {s},\n{s}, {s}, and {s}.\n", .{ authors[0], authors[1], authors[2], authors[3], authors[4], authors[5] });
        },
        7 => {
            try writer.print("Written by {s}, {s}, {s},\n{s}, {s}, {s}, and {s}.\n", .{ authors[0], authors[1], authors[2], authors[3], authors[4], authors[5], authors[6] });
        },
        8 => {
            try writer.print("Written by {s}, {s}, {s},\n{s}, {s}, {s}, {s},\nand {s}.\n", .{ authors[0], authors[1], authors[2], authors[3], authors[4], authors[5], authors[6], authors[7] });
        },
        9 => {
            try writer.print("Written by {s}, {s}, {s},\n{s}, {s}, {s}, {s},\n{s}, and {s}.\n", .{ authors[0], authors[1], authors[2], authors[3], authors[4], authors[5], authors[6], authors[7], authors[8] });
        },
        else => {
            try writer.print("Written by {s}, {s}, {s},\n{s}, {s}, {s}, {s},\n{s}, {s} and others.\n", .{ authors[0], authors[1], authors[2], authors[3], authors[4], authors[5], authors[6], authors[7], authors[8] });
        },
    }
}
