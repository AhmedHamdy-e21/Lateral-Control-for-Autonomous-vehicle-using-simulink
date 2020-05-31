function [refPoses, x0, y0, v0, theta0, simStopTime] = ...
    helperCreateReferencePath(scenario)
% Create driver path

% v0    % Initial speed of the ego car           (m/s)
% x0    % Initial x position of ego car          (m)
% y0    % Initial y position of ego car          (m)
% yaw0  % Initial yaw angle of ego car           (degrees)


% Extract ego pose information
restart(scenario);
poses = record(scenario);
x0 = poses(1).ActorPoses(1).Position(1);
y0 = poses(1).ActorPoses(1).Position(2);
v0 = poses(1).ActorPoses(1).Velocity(1);
theta0 = poses(1).ActorPoses(1).Yaw;

% Driver path is a subsampled version of ego poses
numPoints = numel(poses);
refPoses = zeros(numPoints,3);
for n = 1:numPoints
    refPoses(n,:) = [poses(n).ActorPoses(1).Position(1:2), poses(n).ActorPoses(1).Yaw];
end

simStopTime = poses(end).SimulationTime;
