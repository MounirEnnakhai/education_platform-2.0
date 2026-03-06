const std = @import("std");
const Config = @import("../config/config.zig").Config;

pub const HandlerFn = *const fn (
    allocator: std.mem.Allocator,
    config: Config,
    request: *std.http.Server.Request,
    path_params: PathParams,
) void;

const PathParams = struct {
    pairs: [8]Pair = undefined,
    len: usize = 0,

    pub const Pair = struct { key: []const u8, value: []const u8 };

    pub fn get(self: PathParams, key: []const u8) ?[]const u8 {
        for (self.pairs[0..self.len]) |p| {
            if (std.mem.eql(u8, p.key, key)) return p.value;
        }
        return null;
    }
};

const Route = struct {
    method: std.http.Method,
    pattern: []const u8,
    handler: HandlerFn,
};

const auth_ctrl = @import("../controllers/auth.zig");
const class_ctrl = @import("../controllers/class.zig");
const enrollment_ctrl = @import("../controllers/enrollment.zig");
const schedule_ctrl = @import("../controllers/schedule.zig");

const routes = [_]Route{
    // Auth
    .{ .method = .POST, .pattern = "/auth/register", .handler = auth_ctrl.register },
    .{ .method = .POST, .pattern = "/auth/login", .handler = auth_ctrl.login },

    // Classes
    .{ .method = .POST, .pattern = "/classes", .handler = class_ctrl.create },
    .{ .method = .GET, .pattern = "/classes", .handler = class_ctrl.list },
    .{ .method = .GET, .pattern = "/classes/:id", .handler = class_ctrl.getOne },

    // Enrollments
    .{ .method = .POST, .pattern = "/classes/:id/enroll", .handler = enrollment_ctrl.enroll },
    .{ .method = .GET, .pattern = "/classes/:id/enrollments", .handler = enrollment_ctrl.list },

    // Schedules
    .{ .method = .POST, .pattern = "/classes/:id/schedules", .handler = schedule_ctrl.create },
    .{ .method = .GET, .pattern = "/classes/:id/schedules", .handler = schedule_ctrl.list },
};

pub fn dispatch(allocator: std.mem.Allocator, config: Config, request: *std.http.Server.Request) void {
    const raw_path = request.head.target;
    const path = blk: {
        if (std.mem.indexOfScalar(u8, raw_path, '?')) |q| break :blk raw_path[0..q];
        break :blk raw_path;
    };
    const method = request.head.method;

    for (routes) |route| {
        var params = PathParams{};
        if (route.method == method and matchPath(route.pattern, path, &params)) {
            route.handler(allocator, config, request, params);
            return;
        }
    }

    notFound(request);
}

fn matchPath(pattern: []const u8, path: []const u8, params: *PathParams) bool {
    var pat_it = std.mem.splitScalar(u8, pattern, '/');
    var path_it = std.mem.splitScalar(u8, path, '/');

    while (true) {
        const pat_seg = pat_it.next();
        const path_seg = path_it.next();

        if (pat_seg == null and path_seg == null) return true;

        if (pat_seg == null or path_seg == null) return false;

        const p = pat_seg.?;
        const s = path_seg.?;

        if (p.len > 0 and p[0] == ':') {
            if (params.len >= params.pairs.len) return false;
            params.pairs[params.len] = .{ .key = p[1..], .value = s };
            params.len += 1;
        } else {
            if (!std.mem.eql(u8, p, s)) return false;
        }
    }
}

fn notFound(request: *std.http.Server.Request) void {
    request.respond("{\"error\":\"not found\"}", .{
        .status = .not_found,
        .extra_headers = &.{
            .{ .name = "content-type", .value = "application/json" },
        },
    }) catch {};
}
