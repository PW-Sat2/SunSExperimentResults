suns = sunsps9;

suns.ALS_1_normalized_x = (suns.ALSVL1A - suns.ALSVL1C)./(suns.ALSVL1A + suns.ALSVL1C);
suns.ALS_1_normalized_y = (suns.ALSVL1B - suns.ALSVL1D)./(suns.ALSVL1B + suns.ALSVL1D);

suns.ALS_2_normalized_x = (suns.ALSVL2A - suns.ALSVL2C)./(suns.ALSVL2A + suns.ALSVL2C);
suns.ALS_2_normalized_y = (suns.ALSVL2B - suns.ALSVL2D)./(suns.ALSVL2B + suns.ALSVL2D);

suns.ALS_3_normalized_x = (suns.ALSVL3A - suns.ALSVL3C)./(suns.ALSVL3A + suns.ALSVL3C);
suns.ALS_3_normalized_y = (suns.ALSVL3B - suns.ALSVL3D)./(suns.ALSVL3B + suns.ALSVL3D);

start_time = suns.timestamp(1);
suns.timestamp = suns.timestamp - start_time;