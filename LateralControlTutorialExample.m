%% Lateral Control Tutorial
% This example shows how to control the steering angle of a vehicle that is
% following a planned path while changing lanes, using the 
% <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral
% Controller Stanley> block.

%   Copyright 2018 The MathWorks, Inc.

%% Overview
% Vehicle control is the final step in a navigation system and is typically
% accomplished using two independent controllers:
%
% * *Lateral Controller*: Adjust the steering angle such that the vehicle 
% follows the reference path. The controller minimizes the distance between
% the instantaneous vehicle position and the reference path.
% * *Longitudinal Controller*: While following the reference path, maintain the 
% desired speed by controlling the throttle and the brake. The controller 
% minimizes the difference between the heading angle of the vehicle and the 
% orientation of the reference path.
% 
% This example focuses on lateral control in the context of path following
% in a constant longitudinal velocity scenario. In the example, you will:
%  
% # Learn about the algorithm behind the 
% <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral Controller Stanley> block.  
% # Create a <docid:driving_ref#bvm8jbf driving scenario> and generate a 
% reference path for the vehicle to follow.
% # Test the lateral controller in the scenario using a closed-loop 
% Simulink(R) model.
% # Visualize the scenario and the associated simulation results using the
% <docid:driving_ref#mw_59742eb7-dce8-4938-9c2e-44d34c7b8891 Bird's-Eye
% Scope>.

%% Lateral Controller
% The Stanley lateral controller [1] uses a nonlinear control law to
% minimize the cross-track error and the heading angle of the front wheel 
% relative to the reference path. The 
% <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral
% Controller Stanley> block computes the steering angle command 
% that adjusts a vehicle's current pose to match a reference pose, given 
% the vehicle's current velocity and direction.
%
% <<../latControllerCrosstrack.png>>
%
% The controller uses a kinematic bicycle model, ignoring dynamic effects 
% like inertial forces. Therefore, this block is mainly suitable for low-speed environments, 
% where inertial effects are minimal. To control vehicle steering at high 
% speeds, use the <docid:mpc_ref#mw_13041e31-f545-4d5d-98bd-f9106dc52239 Lane Keeping Assist System>
% block in Model Predictive Control Toolbox(TM) which computes optimal control  
% actions while satisfying steering angle constraints using adaptive model  
% predictive control.

%
%% Scenario Creation
% The scenario is created using the 
% <docid:driving_ref#mw_07e6310f-b9c9-4f4c-b2f9-51e31d407766 Driving Scenario Designer> app. 
% This scenario includes a single, 3-lane road and the ego vehicle.
% For detailed steps on adding roads, lanes, and vehicles, see 
% <docid:driving_ug#mw_e49e404a-0301-4634-b5c2-c8a6da2db9f6 Generate Synthetic Detections from an Interactive Driving Scenario>.
% The vehicle starts in the middle lane, then 
% switches to the left lane after entering the curved part of the road, and 
% finally changes back to the middle lane. Throughout the simulation, the 
% vehicle runs at a constant velocity of 10 meters/second. 
% This scenario was exported from the app as a MATLAB(R) function using the
% *Export > Export MATLAB Function* button. The exported 
% function is named |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperCreateDrivingScenario.m') helperCreateDrivingScenario>|.
%
% <<../LaneChangePathFollowing.PNG>>
%

%% Model Setup
% Open the Simulink tutorial model.
%
%   open_system('LateralControlTutorial')
%
open_system('LateralControlTutorial')
snapnow

%%
% The model contains three main components:
%
% # The <docid:driving_ref#mw_c24d94d4-eda0-4afc-a933-ae8ccad7c525 Lateral Controller Stanley> 
% block, which controls the steering angle of the vehicle.
% # A |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','HelperPathAnalyzer.m') HelperPathAnalyzer>|
% block, which provides the reference signal for the lateral controller.
% Given the current pose of the vehicle, it determines the reference pose 
% by searching for the closest point to the vehicle on the reference path.
% # A Vehicle and Environment subsystem, which models the motion of the 
% vehicle using a <docid:vdynblks_ref#mw_663703c2-aa89-4eac-b073-421cdc5818bc Vehicle Body 3DOF>
% block. The subsystem also models the environment using a  
% Scenario Reader helper block.

%%
% Opening the model also runs the 
% |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperLateralControlTutorialSetup.m') helperLateralControlTutorialSetup>|
% script, which initializes data used by the model. The script
% loads certain constants needed by the Simulink model, such as vehicle  
% parameters, controller parameters, the road scenario, and reference poses. 
% In particular, the script calls the previously exported function 
% |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperCreateDrivingScenario.m') helperCreateDrivingScenario>|
% to build the scenario. The script also sets up the buses required for the 
% model by calling |<matlab:openExample('driving/LateralControlTutorialExample','supportingFile','helperCreateLaneSensorBuses.m') helperCreateLaneSensorBuses>|.
%
% You can plot the road and the planned path using:
%
%   helperPlotRoadAndPath(scenario, refPoses)
%
helperPlotRoadAndPath(scenario, refPoses)


%% Simulate Scenario
% When simulating the model, you can open the 
% <docid:driving_ref#mw_59742eb7-dce8-4938-9c2e-44d34c7b8891 Bird's-Eye Scope>
% to analyze the simulation. After opening the scope, click *Find Signals*  
% to set up the signals. Then run the simulation to display the vehicle, 
% the road boundaries, and the lane markings. The image below shows the 
% bird's-eye scope for this example at 25 seconds. At this instant, the 
% vehicle has switched to the left lane.
%
% <<../lateralControlBirdsEyeScope.PNG>>
%
%%
% You can run the full simulation and explore the results of the using the 
% following command:
%
%   sim('LateralControlTutorial');
%
sim('LateralControlTutorial'); % Simulate to end of scenario

%%
% You can also use the Simulink(R) Scope in the Vehicle and Environment 
% subsystem to inspect the performance of the controller as the vehicle 
% follows the planned path. It can be seen that the maximum deviation 
% from the path is less than 0.2 meters and the largest steering angle 
% magnitude is less than 3 degrees.
%
%   scope = 'LateralControlTutorial/Vehicle and Environment/Scope';
%   open_system(scope)
%
scope = 'LateralControlTutorial/Vehicle and Environment/Scope';
open_system(scope);
snapnow

close_system(scope);
close_system('LateralControlTutorial');
close all
clear


%% Conclusions
% This example showed how to simulate lateral control of a vehicle in a 
% lane changing scenario using Simulink.
%
%% References
% [1] Hoffmann, Gabriel M., Claire J. Tomlin, Michael Montemerlo, and 
%     Sebastian Thrun. "Autonomous Automobile Trajectory Tracking for 
%     Off-road Driving: Controller Design, Experimental Validation and 
%     Racing." _American Control Conference_, 2007, pp. 2296-2301.
%% Supporting Functions
%%%
% *helperPlotRoadAndPath* Plot the road and the reference path
%
%   function helperPlotRoadAndPath(scenario,refPoses)
%   %helperPlotRoadAndPath Plot the road and the reference path
%   h = figure('Color','white');
%   ax1 = axes(h, 'Box','on');
%   
%   plot(scenario,'Parent',ax1)
%   hold on
%   plot(ax1,refPoses(:,1),refPoses(:,2),'b')
%   xlim([150, 300])
%   ylim([0 150])
%   ax1.Title = text(0.5,0.5,'Road and Reference Path');
%   end
%
function helperPlotRoadAndPath(scenario,refPoses)
%helperPlotRoadAndPath Plot the road and the reference path
h = figure('Color','white');
ax1 = axes(h, 'Box','on');

plot(scenario,'Parent',ax1)
hold on
plot(ax1,refPoses(:,1),refPoses(:,2),'b')
xlim([150, 300])
ylim([0 150])
ax1.Title = text(0.5,0.5,'Road and Reference Path');
end
