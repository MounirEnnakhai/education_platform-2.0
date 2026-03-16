CREATE TABLE IF NOT EXISTS enrollments (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id   UUID        NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    student_id UUID        NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
    status     VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- a student can only enroll once per class
    UNIQUE (class_id, student_id)
);

CREATE INDEX IF NOT EXISTS idx_enrollments_class_id   ON enrollments(class_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON enrollments(student_id);