Shader "Custom/Jelly"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude("Amplitude", Range(-1, 1)) = 0.25
        _Frequency("Frequency", float) = 1
        _FactorX("FactorX", Range(0, 1)) = 0.8
        _FactorY("FactorX", Range(0, 1)) = 0.25
        _Force("Force", float) = 0
    }
    SubShader
    {
        Blend SrcAlpha OneMinusSrcAlpha

        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half2 uv : TEXCOORD0;
            };

            struct v2f
            {
                half2 uv : TEXCOORD0;
                half4 vertex : SV_POSITION;
            };

            sampler2D_half _MainTex;
            half4 _MainTex_ST;
            half _Amplitude, _Frequency, _FactorX, _FactorY;
            half _Force;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.x += sin(_Time.w * _Frequency - (v.uv[1] * _FactorX)) * _Amplitude * v.uv[1] * _Force;
                v.vertex.y += cos(_Time.w * _Frequency) * _FactorX * _FactorY * _Amplitude * v.uv[1] * _Force;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
