const std = @import("std");

const data = @embedFile("part1.txt");

const digits = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

pub fn main() void {
    const sum = part2(data);
    std.debug.print("sum: {}\n", .{sum});
}

// Concatenates the first and last digit of each line of text. and sums the result from each line.
fn part2(text: []const u8) usize {
    var sum: usize = 0;
    var first: usize = 0;
    var last: usize = 0;

    var lines = std.mem.split(u8, text, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        first = 0;
        last = 0;

        // Find the first digit.
        blk: for (0..line.len) |i| {
            const char = line[i];
            if (std.ascii.isDigit(char)) {
                first = char - '0';
                break;
            }

            for (digits, 1..) |digit, index| {
                if (std.mem.startsWith(u8, line[i..], digit)) {
                    first = @as(u8, @intCast(index));
                    break :blk;
                }
            }
        }

        // Find the last digit.
        var iter = std.mem.reverseIterator(line);
        blk: while (iter.next()) |char| {
            if (std.ascii.isDigit(char)) {
                last = char - '0';
                break;
            }

            for (digits, 1..) |digit, index| {
                if (std.mem.startsWith(u8, line[iter.index..], digit)) {
                    last = @as(u8, @intCast(index));
                    break :blk;
                }
            }
        }
        // std.debug.print("first, last = [{any},{any}]\n", .{ first, last });
        sum += first * 10 + last;
    }

    return sum;
}
