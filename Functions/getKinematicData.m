function[kinematic_params] = getKinematicData(data)
    
    L_HIP_KNE = data.LKNE - data.LHIP;
    L_KNE_ANK = data.LHIP - data.LANK;
    L_ANK_TOE = data.LANK - data.LTOE;


    R_HIP_KNE = data.RKNE - data.RHIP;
    R_KNE_ANK = data.RHIP - data.RANK;
    R_ANK_TOE = data.RANK - data.RTOE;
    
    L_hip_angle = [];
    R_hip_angle = [];
    L_knee_angle = [];
    R_knee_angle = [];
    L_foot_angle = [];
    R_foot_angle = [];
    
    for j=1:length(L_HIP_KNE)
        L_hip_angle = [L_hip_angle; rad2deg(subspace(L_HIP_KNE(j,:,1).',[0,0,1].'))];
        R_hip_angle = [R_hip_angle; rad2deg(subspace(R_HIP_KNE(j,:,1).',[0,0,1].'))];
        L_knee_angle = [L_knee_angle; rad2deg(subspace(L_HIP_KNE(j,:,1).',L_KNE_ANK(j,:,1).'))];
        L_foot_angle = [L_foot_angle; rad2deg(subspace(L_KNE_ANK(j,:,1).',L_ANK_TOE(j,:,1).'))];
        R_knee_angle = [R_knee_angle; rad2deg(subspace(R_HIP_KNE(j,:,1).',R_KNE_ANK(j,:,1).'))];
        R_foot_angle = [R_foot_angle; rad2deg(subspace(R_KNE_ANK(j,:,1).',R_ANK_TOE(j,:,1).'))];

    end
    
    kinematic_params.L_knee_angle = L_knee_angle;
    kinematic_params.R_knee_angle = R_knee_angle;
    kinematic_params.L_hip_angle = L_hip_angle;
    kinematic_params.R_hip_angle = R_hip_angle;
    kinematic_params.L_foot_angle = L_foot_angle;
    kinematic_params.R_foot_angle = R_foot_angle;
    
    kinematic_params.L_ANK_TOE = L_ANK_TOE;
    kinematic_params.R_ANK_TOE = R_ANK_TOE;
    kinematic_params.LANK = data.LANK;
    kinematic_params.RANK = data.RANK;
    kinematic_params.LTOE = data.LTOE;
    kinematic_params.RTOE = data.RTOE;

end