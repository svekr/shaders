Shader "Custom/Shader3" 
{
    Properties 
    {
        _MainTex ("Texture", 2D) = "bump" {}
        _Magnitude ("Magnitude", Range(0, 0.15)) = 0.05
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        GrabPass { "_BackgroundTex" }

        Pass
        {
            Name "BASE"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 uv0 : TEXCOORD0;
                float2 uv2 : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _BackgroundTex;
            float4 _MainTex_ST;
            float _Magnitude;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0.xy = (float2(o.vertex.x, o.vertex.y) + o.vertex.w) * 0.5;
                o.uv0.zw = o.vertex.zw;
                o.uv2 = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 bump = tex2D(_MainTex, i.uv2);
                half2 distortion = UnpackNormal(bump).rg;
                i.uv0.xy += distortion * _Magnitude;
                half4 col = tex2Dproj(_BackgroundTex, UNITY_PROJ_COORD(i.uv0));
                return col;
            }
            ENDCG
        }
    }
}