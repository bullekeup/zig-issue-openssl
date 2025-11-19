const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const bn_module = b.addModule("bn", .{
        .root_source_file = b.path("src/openssl_bn.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    bn_module.linkSystemLibrary("crypto", .{
        .needed = true,
    });

    const bn_exe = b.addExecutable(.{
        .name = "bn",
        .root_module = bn_module,
        //.use_lld = false,
        //.use_llvm = true,
    });

    b.installArtifact(bn_exe);

    const x509_module = b.addModule("x509", .{
        .root_source_file = b.path("src/openssl_x509.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    x509_module.linkSystemLibrary("crypto", .{
        .needed = true,
    });

    const x509_exe = b.addExecutable(.{
        .name = "x509",
        .root_module = x509_module,
    });

    b.installArtifact(x509_exe);
}
