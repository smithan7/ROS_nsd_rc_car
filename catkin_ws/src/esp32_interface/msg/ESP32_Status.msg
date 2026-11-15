# One 50 Hz status line from the ESP32 firmware (protocol v2).
# header.stamp = Jetson time the line was read (reader thread, right after readline).
std_msgs/Header header
uint32 esp_now_us          # ESP32 micros() when the line was printed (wraps ~71.6 min)
int8 mode                  # 0 manual, 1 auto, -1 no receiver, -2 no jetson, -3 auto not armed
bool armed
int32 rc_age_ms            # -1 = never seen
int32 jetson_age_ms        # -1 = never seen
int32 rc_ch3_us
int32 rc_speed_us
int32 rc_steer_us
uint32 jetson_seq          # last accepted command
int32 jetson_speed_us
int32 jetson_steer_us
int32 out_speed_us         # what the ESC / servo are actually given
int32 out_steer_us
uint32 hall_count          # driveshaft revolutions since boot
uint32 hall_last_edge_us
uint32 hall_dt_us
uint32 bad_cmds
float32 driveshaft_rpm     # from the hall fields, decays to 0 when stopped
