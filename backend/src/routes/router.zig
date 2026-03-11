const std = @import("std");
const httpz = @import("httpz");
const Config = @import("../config/config.zig").Config;

const auth_ctrl = @import("../controllers/auth.zig");
const class_ctrl = @import("../controllers/class.zig");
const enrollment_ctrl = @import("../controllers/enrollment.zig");
const schedule_ctrl = @import("../controllers/schedule.zig");

pub fn setup(router: *httpz.Router(Config, httpz.Action(Config))) void {
    // Auth
    router.post("/auth/register", auth_ctrl.register);
    router.post("/auth/login", auth_ctrl.login);

    // Classes
    router.post("/classes", class_ctrl.create);
    router.get("/classes", class_ctrl.list);
    router.get("/classes/:id", class_ctrl.getOne);

    // Enrollments
    router.post("/classes/:id/enroll", enrollment_ctrl.enroll);
    router.get("/classes/:id/enrollments", enrollment_ctrl.list);

    // Schedules
    router.post("/classes/:id/schedules", schedule_ctrl.create);
    router.get("/classes/:id/schedules", schedule_ctrl.list);
}
