const std = @import("std");

const data = @embedFile("part1.txt");

pub fn main() void {
    const sum = part1(data);
    std.debug.print("sum: {}\n", .{sum});
}

// Concatenates the first and last digit of each line of text. and sums the result from each line.
fn part1(text: []const u8) u32 {
    var sum: u32 = 0;
    var first: u8 = 0;
    var last: u8 = 0;

    var lines = std.mem.split(u8, text, "\n");
    while (lines.next()) |line| {
        first = 0;
        last = 0;
        if (line.len == 0) {
            continue;
        }

        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            if (std.ascii.isDigit(line[i])) {
                first = line[i] - '0';
                break;
            }
        }

        i = line.len - 1;
        while (i >= 0) : (i -= 1) {
            if (std.ascii.isDigit(line[i])) {
                last = line[i] - '0';
                break;
            }
        }

        sum += first * 10 + last;
    }

    return sum;
}
