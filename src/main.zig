const std = @import("std");
const dbgPrint = std.debug.print;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();

    const writer = std.io.getStdOut().writer();

    _ = args_iter.next();

    while (args_iter.next()) |arg| {
        if (arg[0] == '-') {
            if (arg.len > 1 and arg[1] == '-') {
                // Option
                const port: []const u8 = "--port=";
                if (std.mem.startsWith(u8, arg, port)) {
                    const port_num = arg[7..];
                    try writer.print("Port: {s}", .{port_num});
                }
            } else {
                // Flag
                for (arg, 0..) |c, i| {
                    if (i == 0) continue;
                    switch (c) {
                        'h' => try help(),
                        's' => try writer.writeAll("Launching in sender mode.\n"),
                        'r' => try writer.writeAll("Launching in reciever mode.\n"),
                        else => try writer.print("Unrecognized flag: {c}.\n", .{c}),
                    }
                }
            }
        } else {
            // File
        }
    }
}

fn help() !void {
    const help_text =
        \\ftt
        \\File Transfer Tool
        \\usage:
        \\    ftt -s [-flags] [--options] <files>
        \\    ftt -r 
        \\
        \\options:
        \\    --port=   Set the port.
        \\    --ip=     Set the IPv4 address.
        \\
        \\flags:
        \\    -h        Open the help menu.
        \\    -s        Start in sender mode.
        \\    -r        Start in reciever mode.
        \\
        \\
    ;
    try std.io.getStdOut().writeAll(help_text);
}
