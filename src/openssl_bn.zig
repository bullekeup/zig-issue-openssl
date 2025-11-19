const std = @import("std");

pub const log_level = std.log.Level.debug;

pub const c = @cImport({
    @cInclude("openssl/bn.h");
});

pub fn main() void {
    std.log.info("*Start test*", .{});

    const value: ?*c.BIGNUM = c.BN_new() orelse {
        std.log.err("Failed to create BN", .{});
        return;
    };
    defer c.BN_free(value);
    _ = c.BN_set_word(value, 1);
    std.log.debug("value: {d}", .{c.BN_get_word(value)});
}
