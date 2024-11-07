const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const clap_dep = b.dependency("clap", .{
        .target = target,
        .optimize = optimize,
    });
    const clap_module = clap_dep.module("clap");

    const plugin = b.addSharedLibrary(.{
        .name = "zig-clap-plugin",
        .root_source_file = b.path("src/plugin.zig"),
        .target = target,
        .optimize = optimize,
    });
    plugin.root_module.addImport("clap", clap_module);
    b.installArtifact(plugin);
}
