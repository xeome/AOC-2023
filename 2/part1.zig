const std = @import("std");

const data = @embedFile("part1.txt");

const max_red: u8 = 12;
const max_green: u8 = 13;
const max_blue: u8 = 14;

const Session = struct {
    red: usize = 0,
    green: usize = 0,
    blue: usize = 0,
};

pub fn main() !void {
    try parse_games(data);
}

fn parse_games(text: []const u8) !void {
    var id_sum: usize = 0;
    var idx: usize = 1;
    var lines = std.mem.split(u8, text, "\n");
    while (lines.next()) |line| : (idx += 1) {
        if (line.len == 0) {
            continue;
        }

        // Start from end of line and work backwards
        var split = std.mem.splitBackwardsSequence(u8, line, ": ");
        const row = split.next();
        var sessions = std.mem.splitSequence(u8, row.?, "; ");
        var game: Session = .{};
        while (sessions.next()) |session| {
            var session_iter = std.mem.splitSequence(u8, session, ", ");
            while (session_iter.next()) |color| {
                var color_iter = std.mem.splitSequence(u8, color, " ");
                const count = try std.fmt.parseInt(u8, color_iter.next().?, 10);
                const col = color_iter.next().?;
                if (std.mem.eql(u8, col, "red") and game.red < count) game.red = count;
                if (std.mem.eql(u8, col, "green") and game.green < count) game.green = count;
                if (std.mem.eql(u8, col, "blue") and game.blue < count) game.blue = count;
            }
        }

        if (game.red <= max_red and game.green <= max_green and game.blue <= max_blue) {
            id_sum += idx;
            std.debug.print("Game {}: {} red, {} green, {} blue\n", .{ idx, game.red, game.green, game.blue });
        }
    }
    std.debug.print("Valid games id sum: {}\n", .{id_sum});
}
