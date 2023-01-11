%% here you can implement the code in order to have some figures ...
%% Code for Measured Data Output

%{
T = 0:0.01:100;

colororder([1 0 0; 0 1 0; 0 0 1]);

figure(1)
subplot(3, 2, 1)
plot(T, PosE(:, 1), T, PosE(:, 2), T, PosE(:, 3));
title("Earth Position")
ylabel("Position (m)")
xlabel("Time (s)")
legend("x", "y", "z")
grid on

subplot(3, 2, 3)
plot(T, VitG(:, 1), T, VitG(:, 2), T, VitG(:, 3) )
title("Body Velocity")
ylabel("Velocity (m/s)")
xlabel("Time (s)")
legend("x", "y", "z")
grid on

subplot(3, 2, 5)
plot(T, AccG(:, 1), T, AccG(:, 2), T, AccG(:, 3))
title("Body Acceleration")
ylabel("Acceleration (m/s^2)")
xlabel("Time (s)")
legend("x", "y", "z")
alpha 0.05
grid on

subplot(3, 2, 2)
plot(T, PosE(:, 4), T, PosE(:, 5), T, PosE(:, 6))
title("Earth Orientation")
ylabel("Orientation (rad)")
xlabel("Time (s)")
legend("phi", "theta", "psi")
grid on

subplot(3, 2, 4)
plot(T, VitG(:, 4), T, VitG(:, 5), T, VitG(:, 6) )
title("Body Angular Velocity")
ylabel("Ang. Velocity (rad/s)")
xlabel("Time (s)")
legend("phi", "theta", "psi")
grid on

subplot(3, 2, 6)
plot(T, AccG(:, 4), T, AccG(:, 5), T, AccG(:, 6))
title("Body Angular Acceleration")
ylabel("Ang. Acceleration (rad/s^2)")
xlabel("Time (s)")
legend("phi", "theta", "psi")
alpha 0.05
grid on

figure(2)
subplot(1, 2, 1)
plot(PosE(:, 1), PosE(:, 2), '-b')
xlabel("Position X")
ylabel("Position Y")
title("XY Trajectory Plot")
axis equal
daspect([1, 1, 1])
grid on

subplot(1, 2, 2)
plot(T, PosE(:, 3), '-b')
set(gca, 'YDir','reverse')longs
xlabel("Time")
ylabel("Position Z")
title("Depth Trajectory Plot")
grid on
%}

%% Code for Simulated Data Output

T = 0:0.01:100;

colororder([1 0 0; 0 1 0; 0 0 1]);

figure(1)
subplot(3, 2, 1)
plot(T, PosE_S(:, 1), T, PosE_S(:, 2), T, PosE_S(:, 3));
title("Earth Position")
ylabel("Position (m)")
xlabel("Time (s)")
legend("x", "y", "z")
grid on

subplot(3, 2, 3)
plot(T, VitB_S(:, 1), T, VitB_S(:, 2), T, VitB_S(:, 3) )
title("Body Velocity")
ylabel("Velocity (m/s)")
xlabel("Time (s)")
legend("x", "y", "z")
grid on

subplot(3, 2, 5)
plot(T, AccB_S(:, 1), T, AccB_S(:, 2), T, AccB_S(:, 3))
title("Body Acceleration")
ylabel("Acceleration (m/s^2)")
xlabel("Time (s)")
legend("x", "y", "z")
alpha 0.05
grid on

subplot(3, 2, 2)
plot(T, PosE_S(:, 4), T, PosE_S(:, 5), T, PosE_S(:, 6))
title("Earth Orientation")
ylabel("Orientation (rad)")
xlabel("Time (s)")
legend("phi", "theta", "psi")
grid on

subplot(3, 2, 4)
plot(T, VitB_S(:, 4), T, VitB_S(:, 5), T, VitB_S(:, 6) )
title("Body Angular Velocity")
ylabel("Ang. Velocity (rad/s)")
xlabel("Time (s)")
legend("phi", "theta", "psi")
grid on

subplot(3, 2, 6)
plot(T, AccB_S(:, 4), T, AccB_S(:, 5), T, AccB_S(:, 6))
title("Body Angular Acceleration")
ylabel("Ang. Acceleration (rad/s^2)")
xlabel("Time (s)")
legend("phi", "theta", "psi")
alpha 0.05
grid on

figure(2)
subplot(1, 2, 1)
plot(PosE_S(:, 1), PosE_S(:, 2), '-b')
xlabel("Position X")
ylabel("Position Y")
title("XY Trajectory Plot")
axis equal
daspect([1, 1, 1])
grid on

subplot(1, 2, 2)
plot(T, PosE_S(:, 3), '-b')
set(gca, 'YDir','reverse')
xlabel("Time")
ylabel("Position Z")
title("Depth Trajectory Plot")
grid on
