function helperCreateSimulinkScenarioData(...
            roadCenters, laneSpecification, simStopTime,...
            scenarioReaderMATFileName)
% helperCreateSimulinkScenarioData Create data for scenario reader block
% New scenario will not include ego vehicle because ego will be
% controlled by the simulation

%   Copyright 2018 The MathWorks, Inc.

% Create scenario container with one large sample step
scenarioStopTime = simStopTime*1.1;
scenario = drivingScenario(...
    'SampleTime', simStopTime,...
    'StopTime', scenarioStopTime);

road(scenario, roadCenters, 'Lanes', laneSpecification);

% Add dummy vehicle as at least one car is required for the
% scenario reader block
dummyActor = vehicle(scenario, ...
    'ClassID', 1);
speed = 1;
distance = speed * scenarioStopTime;
startPosition = [-1000 0 0];
endPosition = startPosition + [distance 0 0 ];
waypoints = [startPosition; endPosition];
path(dummyActor, waypoints, speed);

%% Save the Scenario to a File format used by scenario reader
vehiclePoses = record(scenario); %#ok<NASGU>

% Obtain lane marking vertices and faces
[LaneMarkingVertices, LaneMarkingFaces] = laneMarkingVertices(scenario); 

% Obtain road boundaries from the scenario and convert them from cell to
% struct for saving
roads = roadBoundaries(scenario);
RoadBoundaries = cell2struct(roads, 'RoadBoundaries',1); %#ok<NASGU>

% Obtain the road network suitable for the scenario reader
RoadNetwork = driving.scenario.internal.getRoadNetwork(scenario);  %#ok<NASGU>

save(scenarioReaderMATFileName,...
    'LaneMarkingFaces', ...
    'LaneMarkingVertices',  ...
    'RoadBoundaries', ...
    'RoadNetwork', ...
    'vehiclePoses');
