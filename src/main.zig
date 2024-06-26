const std = @import("std");

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    var sfb = std.heap.stackFallback(64 * 64, gpa.allocator());
    const allocator = sfb.get();
    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();

    const stdout = std.io.getStdOut().writer();

    // Assume OS will give program name as first argument and skip it
    _ = args_iter.skip();

    while (args_iter.next()) |arg| {
        if (arg[0] == '-') {
            if (arg.len > 1 and arg[1] == '-') {
                // Option
                if (std.mem.startsWith(u8, arg, "--port=")) {
                    const port_num = arg[7..];
                    try stdout.print("Port: {s}\n", .{port_num});
                }
                if (std.mem.startsWith(u8, arg, "--ip=")) {
                    const ip_address = arg[5..];
                    try stdout.print("IP Address: {s}\n", .{ip_address});
                }
            } else {
                // Flag
                for (arg, 0..) |c, i| {
                    if (i == 0) continue;
                    switch (c) {
                        'h' => try help(stdout),
                        's' => try stdout.writeAll("Launching in sender mode.\n"),
                        'r' => try stdout.writeAll("Launching in receiver mode.\n"),
                        else => try stdout.print("Unrecognized flag: {c}.\n", .{c}),
                    }
                }
            }
        } else {
            // File
        }
    }
}

fn help(writer: anytype) !void {
    try writer.writeAll(
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
        \\    -r        Start in receiver mode.
        \\
        \\
    );
}
