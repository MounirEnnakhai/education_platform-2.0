const std = @import("std");

pub fn build(b: *std.Build) void {
    const target   = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const httpz_dep  = b.dependency("httpz",  .{ .target = target, .optimize = optimize });
    const sqlite_dep = b.dependency("sqlite", .{ .target = target, .optimize = optimize });

    // ── Executable ────────────────────────────────────────────────────────────
    // Zig 0.15.2: use root_module = b.createModule(...) not root_source_file
    const exe = b.addExecutable(.{
        .name        = "edu-platform",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target           = target,
            .optimize         = optimize,
            .imports          = &.{
                .{ .name = "httpz",  .module = httpz_dep.module("httpz")  },
                .{ .name = "sqlite", .module = sqlite_dep.module("sqlite") },
            },
        }),
    });
    b.installArtifact(exe);

    // ── Run: zig build run ────────────────────────────────────────────────────
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);
    const run_step = b.step("run", "Run the server");
    run_step.dependOn(&run_cmd.step);

    // ── Test: zig build test ──────────────────────────────────────────────────
    const unit_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target           = target,
            .optimize         = optimize,
            .imports          = &.{
                .{ .name = "httpz",  .module = httpz_dep.module("httpz")  },
                .{ .name = "sqlite", .module = sqlite_dep.module("sqlite") },
            },
        }),
    });
    const run_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);
}
