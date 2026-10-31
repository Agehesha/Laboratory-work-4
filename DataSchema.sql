CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY,
    PRIMARY KEY (user_id)
);

CREATE TABLE recovery_progress (
    progress_id INTEGER GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL,
    result_change FLOAT NOT NULL,
    PRIMARY KEY (progress_id),
    UNIQUE (user_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE rehabilitation_trainings (
    training_id INTEGER GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (training_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE rehabilitation_exercises (
    exercise_id INTEGER GENERATED ALWAYS AS IDENTITY,
    training_id INTEGER NOT NULL,
    PRIMARY KEY (exercise_id),
    FOREIGN KEY (training_id)
        REFERENCES rehabilitation_trainings(training_id)
);

CREATE TABLE user_movements (
    movement_id INTEGER GENERATED ALWAYS AS IDENTITY,
    exercise_id INTEGER NOT NULL,
    body_position VARCHAR(200) NOT NULL,
    PRIMARY KEY (movement_id),
    FOREIGN KEY (exercise_id)
        REFERENCES rehabilitation_exercises(exercise_id),
    CHECK (body_position ~ '^.{3,200}$')
);

CREATE TABLE training_results (
    training_result_id INTEGER GENERATED ALWAYS AS IDENTITY,
    training_id INTEGER NOT NULL,
    progress_id INTEGER,
    PRIMARY KEY (training_result_id),
    UNIQUE (training_id),
    FOREIGN KEY (training_id)
        REFERENCES rehabilitation_trainings(training_id),
    FOREIGN KEY (progress_id)
        REFERENCES recovery_progress(progress_id)
);

CREATE TABLE gait_parameters (
    gait_parameter_id INTEGER GENERATED ALWAYS AS IDENTITY,
    training_result_id INTEGER NOT NULL,
    tempo FLOAT NOT NULL,
    symmetry FLOAT NOT NULL,
    duration FLOAT NOT NULL,
    step_characteristics VARCHAR(200) NOT NULL,
    PRIMARY KEY (gait_parameter_id),
    UNIQUE (training_result_id),
    FOREIGN KEY (training_result_id)
        REFERENCES training_results(training_result_id),
    CHECK (tempo >= 0),
    CHECK (symmetry >= 0 AND symmetry <= 100),
    CHECK (duration > 0),
    CHECK (step_characteristics ~ '^.{3,200}$')
);

CREATE TABLE movement_correctness (
    correctness_id INTEGER GENERATED ALWAYS AS IDENTITY,
    training_result_id INTEGER NOT NULL,
    compliance_degree FLOAT NOT NULL,
    PRIMARY KEY (correctness_id),
    UNIQUE (training_result_id),
    FOREIGN KEY (training_result_id)
        REFERENCES training_results(training_result_id),
    CHECK (compliance_degree >= 0 AND compliance_degree <= 100)
);

CREATE TABLE feedbacks (
    feedback_id INTEGER GENERATED ALWAYS AS IDENTITY,
    training_result_id INTEGER NOT NULL,
    PRIMARY KEY (feedback_id),
    UNIQUE (training_result_id),
    FOREIGN KEY (training_result_id)
        REFERENCES training_results(training_result_id)
);
