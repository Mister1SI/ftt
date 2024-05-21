const std = @import("std");
const dbgPrint = std.debug.print;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();

    const stdout = std.io.getStdOut();
    defer stdout.close();
    // const writer = stdout.writer();

    _ = args_iter.next();

    while (args_iter.next()) |arg| {
        if (arg[0] == '-') {
            if (arg[1] == '-') {
                // Option
            } else {
                // Flag
            }
        } else {
            // File
        }
    }
}

fn help() !void {
    const help_text =
        \\This is really useful help text.
        \\It's helping you.
        \\You are being helped.
        \\Do not question.
        \\
    ;
    try std.io.getStdOut().writeAll(help_text);
}
