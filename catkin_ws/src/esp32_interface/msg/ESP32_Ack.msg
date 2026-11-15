# ESP32 acknowledgement of one command (timestamp echo, protocol v2).
# header.stamp = Jetson time the ack was read.
std_msgs/Header header
uint32 seq
uint32 esp_rx_us           # ESP32 micros() when the command line was accepted
int8 mode
int32 out_speed_us         # outputs after applying this command (clamped / failsafe)
int32 out_steer_us
float32 round_trip_s       # Jetson write -> ack read; NaN if the send was not tracked
