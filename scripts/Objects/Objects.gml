function TreeObject(model) constructor {
    var dist = random(1000) + 200;
    var angle = random(2 * pi);
    x = dist * cos(angle);
    y = -dist * sin(angle);
    self.model = model;
    transform = matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1);
}

function TerrainObject(model) constructor {
    var dist = random(3000) + 2000;
    var angle = random(2 * pi);
    var scale = random_range(10, 20);
    x = dist * cos(angle);
    y = -dist * sin(angle);
    self.model = model;
    transform = matrix_build(x, y, random_range(-100, -25), 0, 0, angle, scale, scale, scale);
}

function LargeTerrainObject(model) constructor {
    var dist = random(10000) + 7500;
    var angle = random(2 * pi);
    var scale = random_range(20, 40);
    x = dist * cos(angle);
    y = -dist * sin(angle);
    self.model = model;
    transform = matrix_build(x, y, random_range(-250, -100), 0, 0, angle, scale, scale, scale);
}

function FloorObject(model) constructor {
    x = 0;
    y = 0;
    self.model = model;
    transform = matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1);
}

function PlayerObject() constructor {
    x = 50;
    y = 50;
    z = 0;
    zspeed = 0;
    direction = 0;
    pitch = -30;
    face_direction = 180;
    distance = 40;
    frame = 0;
};