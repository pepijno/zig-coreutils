const std = @import("std");
const truefalse = @import("truefalse.zig").trueFalse(0);

pub fn main() !void {
    try truefalse.true_false_main();
}
