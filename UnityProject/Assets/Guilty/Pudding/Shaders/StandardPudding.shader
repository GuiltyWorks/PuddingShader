// Copyright (c) 2022 Guilty
// MIT License
// GitHub : https://github.com/GuiltyWorks
// Twitter : @GuiltyWorks_VRC
// EMail : guiltyworks@protonmail.com

Shader "Guilty/StandardPudding" {
    Properties {
        _CaramelColor ("Caramel Color", Color) = (0.5529412, 0.2431373, 0.08235294, 1.0)
        _PuddingColor ("Pudding Color", Color) = (0.9333333, 0.8705882, 0.427451, 1.0)
        _BackgroundColor ("Background Color", Color) = (1, 0.9607843, 0.7490196, 1.0)
        _Glossiness ("Smoothness", Range(0.0, 1.0)) = 0.5
        _Metallic ("Metallic", Range(0.0, 1.0)) = 0.0
        _UpperSurfaceRadius ("Upper Surface Radius", Range(0.0, 1.0)) = 0.25
        _UpperSurfaceWidth ("Upper Surface Width", Range(0.0, 1.0)) = 0.65
        _UpperHeight ("Upper Height", Range(0.0, 1.0)) = 0.5
        _LowerSurfaceRadius ("Lower Surface Radius", Range(0.0, 1.0)) = 0.5
        _LowerSurfaceWidth ("Lower Surface Width", Range(0.0, 1.0)) = 1.0
        _LowerHeight ("Lower Height", Range(0.0, -1.0)) = -0.5
        _Resolution ("Resolution", Range(1.0, 64.0)) = 8.0
        _PuddingSize ("Pudding Size", Range(0.0, 1.0)) = 1.0
        _Angle ("Angle", Range(-180.0, 180.0)) = -20.0
        [MaterialToggle] _Shift ("Shift", Float ) = 1.0
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
        }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input {
            float3 worldPos;
        };

        float4 _CaramelColor;
        float4 _PuddingColor;
        float4 _BackgroundColor;
        float _Glossiness;
        float _Metallic;
        float _UpperSurfaceRadius;
        float _UpperSurfaceWidth;
        float _UpperHeight;
        float _LowerSurfaceRadius;
        float _LowerSurfaceWidth;
        float _LowerHeight;
        float _Resolution;
        float _PuddingSize;
        float _Angle;
        float _Shift;

        void surf(Input IN, inout SurfaceOutputStandard o) {
            float3 worldPos = mul(UNITY_MATRIX_V, float4(IN.worldPos, 1.0)).xyz;
            float2 screenPos = -(round(worldPos.xy / worldPos.z * 100000000.0) / 100000000.0) * _Resolution;
            screenPos = ((frac((float2(screenPos.x, (screenPos.y + ((step(0.5, fmod(round(abs(screenPos.x)), 2.0)) * 0.5) * _Shift))) - 0.5)) - 0.5) * (32.0 + ((-31.0) * _PuddingSize))) * 2.0;
            screenPos = mul(float2x2(cos(_Angle / 180.0 * UNITY_PI), -sin(_Angle / 180.0 * UNITY_PI), sin(_Angle / 180.0 * UNITY_PI), cos(_Angle / 180.0 * UNITY_PI)), screenPos);
            float isInCaramel = step(((pow(screenPos.x, 2.0) / pow((_UpperSurfaceWidth * 0.8), 2.0)) + (pow((screenPos.y - _UpperHeight), 2.0) / pow((_UpperSurfaceRadius / 2.0), 2.0))), 1.0);
            float node_7523 = ((_UpperHeight - _LowerHeight) / ((_LowerSurfaceWidth * 0.8) - (_UpperSurfaceWidth * 0.8)));
            float node_2043 = ((_UpperHeight / node_7523) - (-(_UpperSurfaceWidth * 0.8)));
            float isInPudding = (saturate((((step(screenPos.y, ((screenPos.x - node_2043) * (-node_7523))) * step(screenPos.y, ((screenPos.x + node_2043) * node_7523))) * (step(screenPos.y, _UpperHeight) * step(_LowerHeight, screenPos.y))) - isInCaramel)) + (step(((pow(screenPos.x, 2.0) / pow((_LowerSurfaceWidth * 0.8), 2.0)) + (pow((screenPos.y - _LowerHeight), 2.0) / pow((_LowerSurfaceRadius / 2.0), 2.0))), 1.0) * step(screenPos.y, _LowerHeight)));
            float4 c = (((isInCaramel * _CaramelColor) + (isInPudding * _PuddingColor)) + ((1.0 - (isInCaramel + isInPudding)) * _BackgroundColor));
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
