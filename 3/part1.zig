const std = @import("std");

const data = @embedFile("part1.txt");

const mem = std.mem;

pub fn main() !void {
    var line_iterator = mem.tokenizeScalar(u8, data, '\n');
    var prev_line: ?[]const u8 = null;
    var next_line: ?[]const u8 = null;
    var sum: u32 = 0;
    while (line_iterator.next()) |line| {
        // Skip empty lines
        if (line.len == 0) {
            continue;
        }
        next_line = null;
        // Iterate over each character in the line
        var i: usize = 0;
        lineblk: while (i < line.len) : (i += 1) {
            var c = line[i];
            if (std.ascii.isDigit(c)) {
                // Found a digit, now find the end of the number
                const start = i;
                while (i < line.len) : (i += 1) {
                    c = line[i];
                    if (!std.ascii.isDigit(c)) {
                        break;
                    }
                }
                const end = i;
                const part = line[start..end];
                const start_x = start;
                const end_x = end;

                // Check if the part is adjacent to a symbol
                // Check the row above
                if (prev_line != null) {
                    const prev_start_x = if (start_x == 0) 0 else start_x - 1;
                    const prev_end_x = if (end_x < prev_line.?.len) end_x + 1 else prev_line.?.len;
                    if (prev_start_x >= 0 and prev_end_x <= prev_line.?.len) {
                        const prev_part = prev_line.?[prev_start_x..prev_end_x];
                        // Check if prev_part contains a symbol
                        var j: usize = 0;
                        while (j < prev_part.len) : (j += 1) {
                            const ch = prev_part[j];
                            if (ch != '.' and !std.ascii.isDigit(ch)) {
                                std.debug.print("part: {s}\n", .{part});
                                sum += try std.fmt.parseInt(u32, part, 10);
                                continue :lineblk;
                            }
                        }
                    }
                }

                // Check if we are on the last line
                if (line_iterator.index + line.len >= data.len) {
                    continue;
                }
                // Check the row below
                next_line = line_iterator.buffer[line_iterator.index + 1 .. line_iterator.index + line.len + 1];
                if (next_line != null) {
                    const next_start_x = if (start_x == 0) 0 else start_x - 1;
                    const next_end_x = if (end_x < next_line.?.len) end_x + 1 else next_line.?.len;
                    if (next_start_x >= 0 and next_end_x <= next_line.?.len) {
                        const next_part = next_line.?[next_start_x..next_end_x];
                        // Check if next_part contains a symbol
                        var j: usize = 0;
                        while (j < next_part.len) : (j += 1) {
                            const ch = next_part[j];
                            if (ch != '.' and !std.ascii.isDigit(ch)) {
                                std.debug.print("part: {s}\n", .{part});
                                sum += try std.fmt.parseInt(u32, part, 10);
                                continue :lineblk;
                            }
                        }
                    }
                }

                // Check neighbors on the same line (left and right)
                if (start_x > 0) {
                    const left = line[start_x - 1];
                    if (left != '.' and !std.ascii.isDigit(left)) {
                        std.debug.print("part: {s}\n", .{part});
                        sum += try std.fmt.parseInt(u32, part, 10);
                        continue :lineblk;
                    }
                }

                if (end_x < line.len) {
                    const right = line[end_x];
                    if (right != '.' and !std.ascii.isDigit(right)) {
                        std.debug.print("part: {s}\n", .{part});
                        sum += try std.fmt.parseInt(u32, part, 10);
                        continue :lineblk;
                    }
                }
            }
        }

        prev_line = line;
    }
    std.debug.print("sum: {d}\n", .{sum});
}
