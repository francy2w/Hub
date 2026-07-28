local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")
local LocalPlayer       = Players.LocalPlayer

-- ==========================================
-- RUTA PREGRABADA (290 waypoints)
-- ==========================================
local Path = {
        Vector3.new(-5037.882, -259.046, -97.679),
        Vector3.new(-5036.569, -259.045, -91.198),
        Vector3.new(-5035.173, -259.037, -84.999),
        Vector3.new(-5033.615, -259.122, -78.409),
        Vector3.new(-5031.959, -259.099, -70.938),
        Vector3.new(-5030.613, -259.094, -63.357),
        Vector3.new(-5029.263, -259.030, -54.317),
        Vector3.new(-5027.802, -259.095, -45.501),
        Vector3.new(-5026.355, -259.100, -36.198),
        Vector3.new(-5024.699, -259.094, -26.377),
        Vector3.new(-5022.656, -259.050, -15.603),
        Vector3.new(-5020.764, -259.023, -5.555),
        Vector3.new(-5018.806, -259.025, 5.373),
        Vector3.new(-5016.841, -259.026, 17.004),
        Vector3.new(-5014.946, -259.026, 28.868),
        Vector3.new(-5013.117, -259.032, 40.916),
        Vector3.new(-5011.095, -259.024, 54.899),
        Vector3.new(-5009.068, -259.031, 68.256),
        Vector3.new(-5007.180, -259.031, 80.951),
        Vector3.new(-5005.149, -259.029, 93.978),
        Vector3.new(-5002.728, -259.029, 108.446),
        Vector3.new(-5000.273, -259.029, 122.417),
        Vector3.new(-4997.682, -259.030, 136.713),
        Vector3.new(-4994.919, -259.031, 151.633),
        Vector3.new(-4992.171, -259.031, 166.267),
        Vector3.new(-4988.749, -259.031, 184.349),
        Vector3.new(-4985.351, -259.032, 202.211),
        Vector3.new(-4982.459, -259.043, 217.392),
        Vector3.new(-4978.847, -259.031, 236.371),
        Vector3.new(-4975.958, -259.067, 254.813),
        Vector3.new(-4973.055, -259.051, 274.630),
        Vector3.new(-4970.448, -259.032, 293.794),
        Vector3.new(-4968.059, -259.032, 312.227),
        Vector3.new(-4965.730, -259.033, 329.483),
        Vector3.new(-4963.279, -259.031, 346.967),
        Vector3.new(-4960.494, -259.033, 366.149),
        Vector3.new(-4957.817, -259.032, 384.087),
        Vector3.new(-4954.904, -259.032, 402.210),
        Vector3.new(-4951.918, -259.035, 420.539),
        Vector3.new(-4948.483, -259.035, 440.605),
        Vector3.new(-4945.173, -259.033, 459.320),
        Vector3.new(-4941.487, -259.033, 479.808),
        Vector3.new(-4937.738, -259.034, 500.514),
        Vector3.new(-4934.243, -259.034, 519.826),
        Vector3.new(-4930.653, -259.033, 539.732),
        Vector3.new(-4926.917, -259.033, 560.480),
        Vector3.new(-4923.392, -259.036, 580.124),
        Vector3.new(-4919.550, -259.035, 601.589),
        Vector3.new(-4915.678, -259.035, 623.243),
        Vector3.new(-4911.699, -259.035, 645.504),
        Vector3.new(-4907.847, -259.035, 667.102),
        Vector3.new(-4904.214, -259.035, 687.589),
        Vector3.new(-4900.272, -259.035, 709.953),
        Vector3.new(-4896.538, -259.035, 731.184),
        Vector3.new(-4892.627, -259.036, 753.438),
        Vector3.new(-4888.926, -259.037, 774.530),
        Vector3.new(-4885.241, -259.037, 795.766),
        Vector3.new(-4881.279, -259.039, 818.940),
        Vector3.new(-4877.310, -259.038, 842.267),
        Vector3.new(-4873.614, -259.039, 863.924),
        Vector3.new(-4869.565, -259.039, 887.518),
        Vector3.new(-4865.788, -259.034, 909.412),
        Vector3.new(-4861.809, -259.035, 932.343),
        Vector3.new(-4857.947, -259.039, 954.468),
        Vector3.new(-4853.872, -259.037, 977.629),
        Vector3.new(-4849.661, -259.041, 1001.367),
        Vector3.new(-4845.224, -259.038, 1026.156),
        Vector3.new(-4841.146, -259.036, 1048.705),
        Vector3.new(-4836.831, -259.035, 1072.281),
        Vector3.new(-4832.372, -259.036, 1096.432),
        Vector3.new(-4827.871, -259.037, 1120.686),
        Vector3.new(-4823.603, -259.036, 1143.610),
        Vector3.new(-4819.225, -259.036, 1167.103),
        Vector3.new(-4814.644, -259.037, 1191.654),
        Vector3.new(-4809.951, -259.037, 1216.786),
        Vector3.new(-4805.848, -259.052, 1240.625),
        Vector3.new(-4801.617, -259.041, 1265.517),
        Vector3.new(-4797.363, -259.039, 1291.003),
        Vector3.new(-4793.338, -259.039, 1314.593),
        Vector3.new(-4788.836, -259.039, 1340.210),
        Vector3.new(-4784.550, -259.039, 1363.913),
        Vector3.new(-4779.782, -259.040, 1389.656),
        Vector3.new(-4774.861, -259.041, 1415.964),
        Vector3.new(-4770.088, -259.041, 1441.352),
        Vector3.new(-4765.562, -259.038, 1465.303),
        Vector3.new(-4760.614, -259.039, 1491.311),
        Vector3.new(-4756.005, -259.038, 1515.375),
        Vector3.new(-4751.465, -259.034, 1538.988),
        Vector3.new(-4746.312, -259.039, 1565.686),
        Vector3.new(-4741.612, -259.040, 1589.923),
        Vector3.new(-4736.489, -259.039, 1616.228),
        Vector3.new(-4731.727, -259.041, 1640.563),
        Vector3.new(-4726.524, -259.037, 1666.973),
        Vector3.new(-4721.775, -259.040, 1691.413),
        Vector3.new(-4717.109, -259.059, 1718.026),
        Vector3.new(-4713.008, -259.051, 1742.670),
        Vector3.new(-4708.689, -259.039, 1769.449),
        Vector3.new(-4704.091, -259.038, 1796.224),
        Vector3.new(-4699.604, -259.038, 1822.004),
        Vector3.new(-4695.281, -259.041, 1847.854),
        Vector3.new(-4690.949, -259.041, 1874.810),
        Vector3.new(-4686.771, -259.040, 1901.838),
        Vector3.new(-4682.942, -259.040, 1926.836),
        Vector3.new(-4678.494, -259.039, 1954.985),
        Vector3.new(-4674.298, -259.041, 1981.081),
        Vector3.new(-4669.934, -259.037, 2007.715),
        Vector3.new(-4665.438, -259.044, 2034.914),
        Vector3.new(-4661.175, -259.041, 2060.567),
        Vector3.new(-4656.788, -259.036, 2086.770),
        Vector3.new(-4652.381, -259.042, 2113.015),
        Vector3.new(-4647.948, -259.041, 2139.281),
        Vector3.new(-4643.562, -259.041, 2165.047),
        Vector3.new(-4639.053, -259.045, 2191.359),
        Vector3.new(-4634.426, -259.042, 2218.218),
        Vector3.new(-4630.030, -259.040, 2243.516),
        Vector3.new(-4625.414, -259.038, 2269.885),
        Vector3.new(-4620.770, -259.039, 2296.278),
        Vector3.new(-4616.293, -259.039, 2321.639),
        Vector3.new(-4611.459, -259.039, 2349.142),
        Vector3.new(-4607.018, -259.039, 2374.555),
        Vector3.new(-4602.251, -259.040, 2402.119),
        Vector3.new(-4597.524, -259.038, 2429.716),
        Vector3.new(-4592.826, -259.039, 2457.343),
        Vector3.new(-4588.148, -259.040, 2484.997),
        Vector3.new(-4583.805, -259.041, 2510.544),
        Vector3.new(-4579.141, -259.044, 2537.707),
        Vector3.new(-4574.628, -259.042, 2563.815),
        Vector3.new(-4570.087, -259.041, 2589.937),
        Vector3.new(-4565.321, -259.042, 2617.128),
        Vector3.new(-4560.504, -259.041, 2644.328),
        Vector3.new(-4555.754, -259.040, 2671.006),
        Vector3.new(-4550.862, -259.044, 2698.223),
        Vector3.new(-4545.938, -259.041, 2725.446),
        Vector3.new(-4541.178, -259.043, 2751.609),
        Vector3.new(-4536.293, -259.042, 2778.312),
        Vector3.new(-4531.481, -259.042, 2804.486),
        Vector3.new(-4526.743, -259.038, 2830.130),
        Vector3.new(-4521.486, -259.038, 2858.458),
        Vector3.new(-4516.307, -259.039, 2886.264),
        Vector3.new(-4511.608, -259.039, 2911.405),
        Vector3.new(-4506.703, -259.039, 2937.630),
        Vector3.new(-4501.879, -259.039, 2963.328),
        Vector3.new(-4496.749, -259.038, 2990.646),
        Vector3.new(-4491.721, -259.040, 3017.438),
        Vector3.new(-4486.727, -259.040, 3044.249),
        Vector3.new(-4481.885, -259.041, 3070.547),
        Vector3.new(-4476.826, -259.040, 3098.486),
        Vector3.new(-4471.776, -259.042, 3126.433),
        Vector3.new(-4466.488, -259.043, 3155.458),
        Vector3.new(-4461.635, -259.042, 3181.787),
        Vector3.new(-4456.419, -259.041, 3209.726),
        Vector3.new(-4451.471, -259.040, 3236.044),
        Vector3.new(-4446.292, -259.038, 3263.447),
        Vector3.new(-4441.398, -259.043, 3289.241),
        Vector3.new(-4436.078, -259.041, 3317.191),
        Vector3.new(-4431.032, -259.042, 3343.525),
        Vector3.new(-4425.646, -259.046, 3372.023),
        Vector3.new(-4420.822, -259.052, 3398.951),
        Vector3.new(-4415.961, -259.044, 3426.978),
        Vector3.new(-4411.415, -259.041, 3453.400),
        Vector3.new(-4406.588, -259.039, 3480.884),
        Vector3.new(-4401.564, -259.044, 3508.894),
        Vector3.new(-4396.762, -259.039, 3535.271),
        Vector3.new(-4391.684, -259.040, 3562.715),
        Vector3.new(-4386.527, -259.040, 3590.150),
        Vector3.new(-4381.503, -259.040, 3616.506),
        Vector3.new(-4376.420, -259.041, 3642.860),
        Vector3.new(-4371.058, -259.041, 3670.290),
        Vector3.new(-4365.972, -259.043, 3696.102),
        Vector3.new(-4360.634, -259.044, 3722.982),
        Vector3.new(-4355.355, -259.043, 3749.321),
        Vector3.new(-4349.608, -259.040, 3777.808),
        Vector3.new(-4344.680, -259.054, 3804.218),
        Vector3.new(-4339.667, -259.051, 3831.722),
        Vector3.new(-4335.058, -259.043, 3857.632),
        Vector3.new(-4330.003, -259.041, 3885.691),
        Vector3.new(-4325.136, -259.040, 3912.115),
        Vector3.new(-4319.947, -259.037, 3939.603),
        Vector3.new(-4314.974, -259.040, 3965.457),
        Vector3.new(-4309.952, -259.042, 3991.308),
        Vector3.new(-4304.789, -259.054, 4019.372),
        Vector3.new(-4300.220, -259.056, 4045.303),
        Vector3.new(-4295.430, -259.050, 4073.428),
        Vector3.new(-4291.105, -259.043, 4098.851),
        Vector3.new(-4286.150, -259.040, 4127.509),
        Vector3.new(-4281.555, -259.041, 4153.446),
        Vector3.new(-4276.441, -259.041, 4181.526),
        Vector3.new(-4271.394, -259.041, 4208.505),
        Vector3.new(-4266.277, -259.038, 4235.484),
        Vector3.new(-4261.598, -259.053, 4261.420),
        Vector3.new(-4256.970, -259.051, 4287.371),
        Vector3.new(-4252.409, -259.046, 4313.338),
        Vector3.new(-4247.376, -259.043, 4342.009),
        Vector3.new(-4242.892, -259.045, 4367.430),
        Vector3.new(-4237.908, -259.044, 4395.550),
        Vector3.new(-4233.276, -259.042, 4421.508),
        Vector3.new(-4228.229, -259.037, 4449.617),
        Vector3.new(-4223.532, -259.039, 4475.561),
        Vector3.new(-4218.407, -259.047, 4503.671),
        Vector3.new(-4213.245, -259.041, 4531.781),
        Vector3.new(-4208.054, -259.046, 4559.879),
        Vector3.new(-4202.934, -259.042, 4587.438),
        Vector3.new(-4197.988, -259.042, 4613.913),
        Vector3.new(-4193.674, -259.069, 4639.944),
        Vector3.new(-4189.021, -259.078, 4670.356),
        Vector3.new(-4184.881, -259.056, 4699.180),
        Vector3.new(-4181.033, -259.044, 4726.932),
        Vector3.new(-4177.306, -259.042, 4753.594),
        Vector3.new(-4173.251, -259.041, 4781.875),
        Vector3.new(-4169.155, -259.040, 4809.601),
        Vector3.new(-4165.085, -259.043, 4836.773),
        Vector3.new(-4160.997, -259.044, 4863.950),
        Vector3.new(-4156.809, -259.043, 4891.668),
        Vector3.new(-4152.782, -259.044, 4918.303),
        Vector3.new(-4148.656, -259.044, 4945.477),
        Vector3.new(-4144.527, -259.040, 4972.654),
        Vector3.new(-4140.461, -259.044, 4999.286),
        Vector3.new(-4136.204, -259.045, 5027.007),
        Vector3.new(-4132.180, -259.037, 5053.095),
        Vector3.new(-4127.798, -259.039, 5081.357),
        Vector3.new(-4123.389, -259.039, 5109.612),
        Vector3.new(-4119.211, -259.039, 5136.239),
        Vector3.new(-4114.853, -259.040, 5163.955),
        Vector3.new(-4110.387, -259.039, 5192.215),
        Vector3.new(-4105.916, -259.040, 5220.476),
        Vector3.new(-4101.735, -259.040, 5246.558),
        Vector3.new(-4096.744, -259.049, 5274.732),
        Vector3.new(-4091.548, -259.047, 5302.872),
        Vector3.new(-4086.299, -259.041, 5330.444),
        Vector3.new(-4081.316, -259.040, 5356.946),
        Vector3.new(-4076.706, -259.057, 5384.634),
        Vector3.new(-4072.286, -259.057, 5411.790),
        Vector3.new(-4067.705, -259.044, 5439.480),
        Vector3.new(-4063.211, -259.038, 5466.617),
        Vector3.new(-4058.606, -259.038, 5493.737),
        Vector3.new(-4054.119, -259.044, 5519.762),
        Vector3.new(-4049.581, -259.044, 5545.784),
        Vector3.new(-4045.001, -259.042, 5571.794),
        Vector3.new(-4040.278, -259.043, 5598.340),
        Vector3.new(-4035.404, -259.044, 5625.414),
        Vector3.new(-4030.581, -259.037, 5651.930),
        Vector3.new(-4025.419, -259.040, 5680.065),
        Vector3.new(-4020.631, -259.039, 5706.034),
        Vector3.new(-4015.821, -259.039, 5732.003),
        Vector3.new(-4010.588, -259.039, 5760.135),
        Vector3.new(-4005.337, -259.040, 5788.271),
        Vector3.new(-4000.163, -259.040, 5815.868),
        Vector3.new(-3994.772, -259.041, 5844.548),
        Vector3.new(-3989.454, -259.039, 5872.679),
        Vector3.new(-3984.500, -259.040, 5898.642),
        Vector3.new(-3979.095, -259.041, 5926.759),
        Vector3.new(-3974.083, -259.038, 5952.723),
        Vector3.new(-3969.050, -259.044, 5978.673),
        Vector3.new(-3963.857, -259.044, 6005.161),
        Vector3.new(-3958.398, -259.041, 6032.714),
        Vector3.new(-3952.794, -259.041, 6060.798),
        Vector3.new(-3947.590, -259.039, 6086.705),
        Vector3.new(-3942.342, -259.042, 6112.609),
        Vector3.new(-3936.703, -259.038, 6140.118),
        Vector3.new(-3931.234, -259.044, 6166.541),
        Vector3.new(-3925.397, -259.041, 6194.576),
        Vector3.new(-3919.976, -259.043, 6220.447),
        Vector3.new(-3931.234, -259.044, 6166.541),
        Vector3.new(-3925.397, -259.041, 6194.576),
        Vector3.new(-3919.976, -259.043, 6220.447),
        Vector3.new(-3914.411, -259.038, 6246.845),
        Vector3.new(-3909.112, -259.040, 6272.178),
        Vector3.new(-3903.755, -259.063, 6300.305),
        Vector3.new(-3898.540, -259.058, 6328.451),
        Vector3.new(-3893.464, -259.045, 6356.634),
        Vector3.new(-3888.557, -259.041, 6383.713),
        Vector3.new(-3883.553, -259.041, 6410.776),
        Vector3.new(-3878.532, -259.041, 6437.277),
        Vector3.new(-3873.595, -259.041, 6462.674),
        Vector3.new(-3867.807, -259.041, 6491.836),
        Vector3.new(-3862.893, -259.055, 6518.923),
        Vector3.new(-3858.184, -259.058, 6545.478),
        Vector3.new(-3853.710, -259.049, 6571.515),
        Vector3.new(-3849.011, -259.046, 6599.190),
        Vector3.new(-3844.114, -259.045, 6627.949),
        Vector3.new(-3839.372, -259.043, 6655.619),
        Vector3.new(-3834.794, -259.042, 6682.185),
        Vector3.new(-3829.999, -259.046, 6709.841),
        Vector3.new(-3825.074, -259.039, 6738.025),
        Vector3.new(-3820.111, -259.039, 6766.208),
        Vector3.new(-3815.495, -259.039, 6792.223),
        Vector3.new(-3810.455, -259.041, 6820.401),
        Vector3.new(-3805.387, -259.043, 6848.570),
        Vector3.new(-3800.683, -259.040, 6874.568),
        Vector3.new(-3795.563, -259.041, 6902.732),
        Vector3.new(-3790.610, -259.040, 6929.809),
        Vector3.new(-3785.330, -259.039, 6958.511),
        Vector3.new(-3780.322, -259.039, 6985.586),
        Vector3.new(-3775.179, -259.040, 7013.199),
        Vector3.new(-3769.891, -259.041, 7041.343),
        Vector3.new(-3764.883, -259.041, 7067.862),
        Vector3.new(-3759.652, -259.041, 7095.467),
        Vector3.new(-3754.608, -259.045, 7121.988),
        Vector3.new(-3749.332, -259.043, 7149.581),
        Vector3.new(-3744.340, -259.043, 7175.550),
        Vector3.new(-3739.225, -259.043, 7202.056),
        Vector3.new(-3733.980, -259.042, 7229.090),
        Vector3.new(-3728.386, -259.043, 7257.745),
        Vector3.new(-3722.759, -259.042, 7286.394),
        Vector3.new(-3716.881, -259.037, 7316.103),
        Vector3.new(-3710.870, -259.041, 7346.348),
        Vector3.new(-3704.607, -259.038, 7377.678),
        Vector3.new(-3698.414, -259.039, 7408.458),
        Vector3.new(-3692.661, -259.039, 7437.085),
        Vector3.new(-3687.187, -259.043, 7465.201),
        Vector3.new(-3681.827, -259.042, 7493.344),
        Vector3.new(-3676.695, -259.050, 7521.528),
        Vector3.new(-3671.866, -259.050, 7549.756),
        Vector3.new(-3667.487, -259.045, 7576.386),
        Vector3.new(-3663.483, -259.053, 7601.964),
        Vector3.new(-3659.354, -259.061, 7630.859),
        Vector3.new(-3655.694, -259.048, 7658.156),
        Vector3.new(-3651.936, -259.041, 7684.881),
        Vector3.new(-3647.784, -259.049, 7713.209),
        Vector3.new(-3643.646, -259.061, 7739.311),
        Vector3.new(-3638.539, -259.087, 7767.462),
        Vector3.new(-3633.617, -259.063, 7793.406),
        Vector3.new(-3628.197, -259.049, 7820.933),
        Vector3.new(-3622.677, -259.040, 7848.440),
        Vector3.new(-3617.568, -259.041, 7875.461),
        Vector3.new(-3613.009, -259.054, 7901.458),
        Vector3.new(-3608.688, -259.050, 7927.493),
        Vector3.new(-3604.244, -259.038, 7953.522),
        Vector3.new(-3599.148, -259.052, 7981.655),
        Vector3.new(-3593.909, -259.048, 8009.765),
        Vector3.new(-3588.953, -259.041, 8035.691),
        Vector3.new(-3584.004, -259.038, 8061.617),
        Vector3.new(-3579.155, -259.039, 8087.558),
        Vector3.new(-3574.051, -259.039, 8115.689),
        Vector3.new(-3569.470, -259.040, 8141.682),
        Vector3.new(-3564.631, -259.040, 8169.864),
        Vector3.new(-3559.600, -259.045, 8198.018),
        Vector3.new(-3554.294, -259.046, 8226.119),
        Vector3.new(-3549.224, -259.047, 8252.022),
        Vector3.new(-3543.500, -259.072, 8278.358),
        Vector3.new(-3537.282, -259.066, 8305.694),
        Vector3.new(-3531.224, -259.054, 8331.378),
        Vector3.new(-3525.022, -259.047, 8357.028),
        Vector3.new(-3518.208, -259.045, 8384.784),
        Vector3.new(-3511.738, -259.041, 8410.934),
        Vector3.new(-3504.842, -259.038, 8438.679),
        Vector3.new(-3498.323, -259.039, 8464.817),
        Vector3.new(-3491.250, -259.039, 8493.084),
        Vector3.new(-3484.543, -259.039, 8519.755),
        Vector3.new(-3477.545, -259.038, 8547.492),
        Vector3.new(-3471.185, -259.065, 8574.808),
        Vector3.new(-3465.441, -259.085, 8600.516),
        Vector3.new(-3459.605, -259.067, 8627.556),
        Vector3.new(-3454.186, -259.059, 8653.203),
}

-- ==========================================
-- CONFIGURACIÓN
-- ==========================================
local VELOCIDAD_NORMAL       = 250
local VELOCIDAD_CURVA        = 250
local FRENAR_DISTANCIA       = 70
local DISTANCIA_LLEGADA_WP   = 20
local FUERZA_MOTOR           = 500000
local UMBRAL_VUELO           = 12
local TIEMPO_ATASCO          = 4
local VEL_MIN_ATASCO         = 5
local TORQUE_ALINEACION      = 200000
local RESPONSIVIDAD_ALINEAC  = 80
local PITCH_MAX              = 0.25
local ALTURA_SUELO_RAYCAST   = 60
local DOWNFORCE_BASE         = 5000
local DOWNFORCE_FUERTE       = 80000
local ALTURA_ALTA            = 6

-- Click inicial (subir marcha)
local CLICK_INICIAL_X        = 862
local CLICK_INICIAL_Y        = 171
local CLICK_INICIAL_DURACION = 2.0

local PUNTO_INICIO = Path[1]

-- ==========================================
-- ESTADO
-- ==========================================
local modoAuto       = false
local currentSeat    = nil
local currentVehicle = nil
local rootPart       = nil
local constraints    = {}
local constraintRefs = nil
local wpIndex        = 1
local stuckTimer     = 0
local startTime      = 0
local distanciaRecorrida = 0
local ultimaPos      = nil

-- ==========================================
-- UI — ESTILO MAINTENANCE / FUCKOFF
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheixHubUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- FORWARD DECLARATION de mainFrame (para que el handler de understood lo vea)
local mainFrame

-- ============================================================
-- UI 1: PANTALLA DE INTRO — SIMPLE + DIFUMINADA
-- ============================================================

-- Fondo difuminado de pantalla completa (blur del juego detrás)
local introBg = Instance.new("Frame")
introBg.Size = UDim2.new(1, 0, 1, 0)
introBg.Position = UDim2.new(0, 0, 0, 0)
introBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
introBg.BackgroundTransparency = 0.4  -- medio transparente
introBg.BorderSizePixel = 0
introBg.Parent = screenGui

-- Intentar aplicar blur al fondo del juego (Lighting)
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 24
blurEffect.Parent = game:GetService("Lighting")

-- Panel central (gris medio transparente + difuminado)
local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(0, 360, 0, 340)
introFrame.Position = UDim2.new(0.5, -180, 0.5, -170)
introFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
introFrame.BackgroundTransparency = 0.35  -- gris medio transparente
introFrame.BorderSizePixel = 0
introFrame.Parent = introBg
Instance.new("UICorner", introFrame).CornerRadius = UDim.new(0, 12)

-- Título
local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, -40, 0, 35)
introTitle.Position = UDim2.new(0, 20, 0, 25)
introTitle.BackgroundTransparency = 1
introTitle.Text = "steps for autofarm to work"
introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
introTitle.Font = Enum.Font.SourceSansBold
introTitle.TextSize = 20
introTitle.Parent = introFrame

-- Steps simples
local step1 = Instance.new("TextLabel")
step1.Size = UDim2.new(1, -40, 0, 30)
step1.Position = UDim2.new(0, 20, 0, 75)
step1.BackgroundTransparency = 1
step1.Text = "1. get on a bike"
step1.TextColor3 = Color3.fromRGB(230, 230, 230)
step1.Font = Enum.Font.SourceSansBold
step1.TextSize = 17
step1.TextXAlignment = Enum.TextXAlignment.Left
step1.Parent = introFrame

local step2 = Instance.new("TextLabel")
step2.Size = UDim2.new(1, -40, 0, 45)
step2.Position = UDim2.new(0, 20, 0, 110)
step2.BackgroundTransparency = 1
step2.Text = "2. You'll need to move until you're in 2nd gear or higher"
step2.TextColor3 = Color3.fromRGB(230, 230, 230)
step2.Font = Enum.Font.SourceSansBold
step2.TextSize = 17
step2.TextWrapped = true
step2.TextXAlignment = Enum.TextXAlignment.Left
step2.Parent = introFrame

local step3 = Instance.new("TextLabel")
step3.Size = UDim2.new(1, -40, 0, 30)
step3.Position = UDim2.new(0, 20, 0, 175)
step3.BackgroundTransparency = 1
step3.Text = "3. activate auto farm"
step3.TextColor3 = Color3.fromRGB(230, 230, 230)
step3.Font = Enum.Font.SourceSansBold
step3.TextSize = 17
step3.TextXAlignment = Enum.TextXAlignment.Left
step3.Parent = introFrame

-- Botón understood (empieza ROJO con countdown, luego VERDE)
local understoodButton = Instance.new("TextButton")
understoodButton.Size = UDim2.new(1, -50, 0, 50)
understoodButton.Position = UDim2.new(0, 25, 0, 240)
understoodButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
understoodButton.Text = "3.000"
understoodButton.TextColor3 = Color3.fromRGB(255, 255, 255)
understoodButton.Font = Enum.Font.SourceSansBold
understoodButton.TextSize = 22
understoodButton.BorderSizePixel = 0
understoodButton.Parent = introFrame
Instance.new("UICorner", understoodButton).CornerRadius = UDim.new(0, 8)

-- Variables para el countdown
local countdownActive = true
local countdownStart = tick()
local COUNTDOWN_DURATION = 3.0

-- Countdown rápido con decimales
task.spawn(function()
    while countdownActive do
        local elapsed = tick() - countdownStart
        local remaining = COUNTDOWN_DURATION - elapsed
        if remaining <= 0 then
            understoodButton.Text = "understood"
            understoodButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
            countdownActive = false
            break
        end
        understoodButton.Text = string.format("%.3f", remaining)
        task.wait(0.001)
    end
end)

-- Click en understood (solo funciona cuando ya está verde)
understoodButton.MouseButton1Click:Connect(function()
    if countdownActive then return end
    -- Quitar el blur del Lighting
    pcall(function() blurEffect:Destroy() end)
    introBg:Destroy()
    if mainFrame then
        mainFrame.Visible = true
    end
end)

-- ============================================================
-- UI 2: MENÚ PRINCIPAL (cheixhub + imagen + auto farm + fuck off)
-- ============================================================

-- Panel principal (gris #4A4A4A, esquinas redondeadas ~12px)
mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 360)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(74, 74, 74)  -- #4A4A4A
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false  -- OCULTO hasta que se pulse understood
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Título: "cheixhub" (blanco, grande, arriba)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 45)
title.Position = UDim2.new(0, 20, 0, 20)
title.BackgroundTransparency = 1
title.Text = "cheixhub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 32
title.Parent = mainFrame

-- Imagen debajo de cheixhub — asset de la Roblox Store (cheese)
-- Los assets de tienda NO funcionan con rbxassetid://, hay que usar rbxthumb://
local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(0, 120, 0, 120)
logoImage.Position = UDim2.new(0.5, -60, 0, 70)
logoImage.BackgroundTransparency = 1
logoImage.BorderSizePixel = 0
logoImage.Image = "rbxthumb://type=Asset&id=846791948&w=420&h=420"
logoImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
logoImage.ImageTransparency = 0
logoImage.ScaleType = Enum.ScaleType.Fit
logoImage.Parent = mainFrame

-- Botón 1: "auto farm" (azul lavanda #8494E8)
local autoFarmButton = Instance.new("TextButton")
autoFarmButton.Size = UDim2.new(1, -50, 0, 50)
autoFarmButton.Position = UDim2.new(0, 25, 0, 205)
autoFarmButton.BackgroundColor3 = Color3.fromRGB(132, 148, 232)
autoFarmButton.Text = "auto farm"
autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFarmButton.Font = Enum.Font.SourceSansBold
autoFarmButton.TextSize = 22
autoFarmButton.BorderSizePixel = 0
autoFarmButton.Parent = mainFrame
Instance.new("UICorner", autoFarmButton).CornerRadius = UDim.new(0, 8)

-- Botón 2: "fuck off" (negro #1F1F1F)
local fuckOffButton = Instance.new("TextButton")
fuckOffButton.Size = UDim2.new(1, -50, 0, 50)
fuckOffButton.Position = UDim2.new(0, 25, 0, 270)
fuckOffButton.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
fuckOffButton.Text = "fuck off"
fuckOffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fuckOffButton.Font = Enum.Font.SourceSansBold
fuckOffButton.TextSize = 22
fuckOffButton.BorderSizePixel = 0
fuckOffButton.Parent = mainFrame
Instance.new("UICorner", fuckOffButton).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- FUNCIONES
-- ==========================================
local function LimpiarConstraints()
    for _, c in ipairs(constraints) do
        pcall(function() c:Destroy() end)
    end
    constraints = {}
    constraintRefs = nil
    if currentSeat then
        pcall(function()
            currentSeat.Throttle = 0
            currentSeat.Steer = 0
        end)
    end
end

local function CrearConstraints(primary)
    LimpiarConstraints()
    local comPos = primary.AssemblyCenterOfMass
    local localOffset = primary.CFrame:PointToObjectSpace(comPos)
    local attachment = Instance.new("Attachment")
    attachment.Name = "CheixHubAttachment"
    attachment.Parent = primary
    pcall(function() attachment.Position = localOffset end)

    local linVel = Instance.new("LinearVelocity")
    linVel.Attachment0 = attachment
    linVel.MaxForce = FUERZA_MOTOR
    linVel.RelativeTo = Enum.ActuatorRelativeTo.World
    linVel.VectorVelocity = Vector3.new(0, 0, 0)
    linVel.Parent = primary
    table.insert(constraints, linVel)

    local alignOri = Instance.new("AlignOrientation")
    alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOri.Attachment0 = attachment
    alignOri.MaxTorque = TORQUE_ALINEACION
    alignOri.Responsiveness = RESPONSIVIDAD_ALINEAC
    alignOri.Parent = primary
    table.insert(constraints, alignOri)

    local downForce = Instance.new("VectorForce")
    downForce.Attachment0 = attachment
    downForce.RelativeTo = Enum.ActuatorRelativeTo.World
    downForce.Force = Vector3.new(0, -DOWNFORCE_BASE, 0)
    downForce.Parent = primary
    table.insert(constraints, downForce)

    constraintRefs = { linVel = linVel, alignOri = alignOri, downForce = downForce }
end

local function ObtenerDir(pos, target)
    local a = Vector3.new(pos.X, 0, pos.Z)
    local b = Vector3.new(target.X, 0, target.Z)
    local d = b - a
    if d.Magnitude < 0.1 then return Vector3.new(0, 0, 1), 0 end
    return d.Unit, d.Magnitude
end

local function TeleportarInicio()
    if not currentVehicle then return end
    if rootPart then
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    local startCFrame
    if #Path >= 2 then
        startCFrame = CFrame.lookAt(PUNTO_INICIO, Path[2])
    else
        startCFrame = CFrame.new(PUNTO_INICIO)
    end
    currentVehicle:PivotTo(startCFrame)
    task.wait(0.2)
    wpIndex = 1
    stuckTimer = 0
    startTime = tick()
    distanciaRecorrida = 0
    ultimaPos = PUNTO_INICIO
end

-- ==========================================
-- BOTÓN AUTO FARM (toggle on/off)
-- ==========================================
autoFarmButton.MouseButton1Click:Connect(function()
    modoAuto = not modoAuto
    if modoAuto then
        autoFarmButton.Text = "auto farm: on"
        autoFarmButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)  -- verde cuando ON
        wpIndex = 1
        stuckTimer = 0
        startTime = tick()
        distanciaRecorrida = 0

        -- Click inicial (subir marcha) — 2 segundos
        task.spawn(function()
            pcall(function() VirtualInputManager:SendMouseMoveEvent(CLICK_INICIAL_X, CLICK_INICIAL_Y, game) end)
            task.wait(0.05)
            pcall(function() VirtualInputManager:SendMouseButtonEvent(CLICK_INICIAL_X, CLICK_INICIAL_Y, 0, true, game, 1) end)
            local pasos = 20
            for i = 1, pasos do
                task.wait(CLICK_INICIAL_DURACION / pasos)
                if i % 5 == 0 then
                    pcall(function() VirtualInputManager:SendMouseButtonEvent(CLICK_INICIAL_X, CLICK_INICIAL_Y, 0, true, game, 1) end)
                end
            end
            pcall(function() VirtualInputManager:SendMouseButtonEvent(CLICK_INICIAL_X, CLICK_INICIAL_Y, 0, false, game, 1) end)
            task.wait(0.1)
        end)
    else
        autoFarmButton.Text = "auto farm"
        autoFarmButton.BackgroundColor3 = Color3.fromRGB(132, 148, 232)  -- azul cuando OFF
        LimpiarConstraints()
        currentSeat    = nil
        currentVehicle = nil
        rootPart       = nil
    end
end)

-- ==========================================
-- BOTÓN FUCK OFF (cerrar UI)
-- ==========================================
fuckOffButton.MouseButton1Click:Connect(function()
    -- Detener autofarm si estaba activo
    modoAuto = false
    LimpiarConstraints()
    currentSeat    = nil
    currentVehicle = nil
    rootPart       = nil
    -- Destruir UI
    screenGui:Destroy()
end)

-- ==========================================
-- DRAGGABLE (mover panel con ratón)
-- ==========================================
task.spawn(function()
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            dragInput = input
        end
    end)
    mainFrame.InputEnded:Connect(function(input)
        if input == dragInput then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
end)

-- ==========================================
-- SIMULADOR TECLA W (ganar dinero)
-- ==========================================
task.spawn(function()
    while true do
        if modoAuto and currentSeat then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            end)
        end
        task.wait(0.1)
    end
end)

-- ==========================================
-- LÓGICA PRINCIPAL DEL AUTOFARM
-- ==========================================
RunService.Heartbeat:Connect(function()
    if not modoAuto then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if not (hum.Sit and hum.SeatPart) then
        if currentSeat then
            LimpiarConstraints()
            currentSeat    = nil
            currentVehicle = nil
            rootPart       = nil
            stuckTimer     = 0
        end
        return
    end

    local seat = hum.SeatPart

    -- Inicialización al subirse
    if seat ~= currentSeat then
        LimpiarConstraints()
        currentSeat    = seat
        currentVehicle = seat.Parent
        rootPart       = currentVehicle.PrimaryPart or seat
        pcall(function() rootPart:SetNetworkOwner(LocalPlayer) end)
        for _, p in ipairs(currentVehicle:GetDescendants()) do
            if p:IsA("BasePart") and p.Anchored and p ~= seat then
                pcall(function() p.Anchored = false end)
            end
        end
        CrearConstraints(rootPart)
        TeleportarInicio()
    end

    if not rootPart or not rootPart.Parent then return end

    local pos = rootPart.Position

    -- ¿Llegamos al final?
    if wpIndex > #Path then
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        if constraintRefs and constraintRefs.linVel then
            constraintRefs.linVel.VectorVelocity = Vector3.new(0, 0, 0)
        end
        -- Reiniciar ruta (loop infinito)
        wpIndex = 1
        TeleportarInicio()
        return
    end

    local target = Path[wpIndex]
    local dir, dist = ObtenerDir(pos, target)

    -- ¿Llegamos a este waypoint? Avanzar
    if dist < DISTANCIA_LLEGADA_WP then
        wpIndex = wpIndex + 1
        stuckTimer = 0
        if wpIndex > #Path then return end
        target = Path[wpIndex]
        dir, dist = ObtenerDir(pos, target)
    end

    -- Distancia recorrida
    if ultimaPos then
        distanciaRecorrida = distanciaRecorrida + (pos - ultimaPos).Magnitude
    end
    ultimaPos = pos

    -- Velocidad adaptativa
    local vel = VELOCIDAD_NORMAL
    if dist < FRENAR_DISTANCIA then
        local t = dist / FRENAR_DISTANCIA
        vel = VELOCIDAD_CURVA + (VELOCIDAD_NORMAL - VELOCIDAD_CURVA) * t
    end

    -- Aplicar velocidad (respeta Y para gravedad)
    local targetVel = dir * vel
    local currentVel = rootPart.AssemblyLinearVelocity
    rootPart.AssemblyLinearVelocity = Vector3.new(
        targetVel.X,
        currentVel.Y,
        targetVel.Z
    )
    if constraintRefs and constraintRefs.linVel then
        constraintRefs.linVel.VectorVelocity = Vector3.new(
            targetVel.X,
            currentVel.Y,
            targetVel.Z
        )
    end

    -- AlignOrientation (mantener moto plana)
    if constraintRefs and constraintRefs.alignOri then
        constraintRefs.alignOri.CFrame = CFrame.lookAt(pos, pos + dir, Vector3.new(0, 1, 0))
    end

    -- Anti-wheelie: si pitch alto, forzar plano
    local upVec = rootPart.CFrame.UpVector
    local pitchAmount = 1 - upVec.Y
    if pitchAmount > PITCH_MAX then
        local flatPos = rootPart.Position
        local flatCFrame = CFrame.lookAt(flatPos, flatPos + dir, Vector3.new(0, 1, 0))
        rootPart.CFrame = rootPart.CFrame:Lerp(flatCFrame, 0.3)
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    -- Downforce adaptativo con raycast
    local rayOrigin = pos
    local rayDir = Vector3.new(0, -1, 0) * ALTURA_SUELO_RAYCAST
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {currentVehicle, char}

    local alturaSobreSuelo = ALTURA_ALTA
    pcall(function()
        local rayResult = Workspace:Raycast(rayOrigin, rayDir, raycastParams)
        if rayResult then
            alturaSobreSuelo = (pos - rayResult.Position).Y
        end
    end)

    local downForceY = -DOWNFORCE_BASE
    if alturaSobreSuelo > ALTURA_ALTA then
        downForceY = -DOWNFORCE_FUERTE
    elseif alturaSobreSuelo > 3 then
        local t = (alturaSobreSuelo - 3) / (ALTURA_ALTA - 3)
        downForceY = -DOWNFORCE_BASE - (DOWNFORCE_FUERTE - DOWNFORCE_BASE) * t
    end
    if constraintRefs and constraintRefs.downForce then
        constraintRefs.downForce.Force = Vector3.new(0, downForceY, 0)
    end

    -- Anti-vuelo
    if currentVel.Y > UMBRAL_VUELO and alturaSobreSuelo > 3 then
        rootPart.AssemblyLinearVelocity = Vector3.new(currentVel.X, 0, currentVel.Z)
    end

    -- VehicleSeat (dinero)
    pcall(function()
        currentSeat.Throttle = 1
        currentSeat.Steer = 0
    end)

    -- Detección de atasco
    local velH = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude
    if velH < VEL_MIN_ATASCO then
        stuckTimer = stuckTimer + 0.016
    else
        stuckTimer = 0
    end
    if stuckTimer > TIEMPO_ATASCO then
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        currentVehicle:PivotTo(CFrame.new(target + Vector3.new(0, 5, 0)))
        stuckTimer = 0
        task.wait(0.3)
    end
end)
