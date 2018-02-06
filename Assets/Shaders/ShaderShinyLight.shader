Shader "Custom/ShinyLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlendTex ("Blend Texture", 2D) = "bump" {}
        _BlendAlpha("Blend Alpha", Range(0, 1)) = 0.5
        _BlendPos("Blend Position", Range(-1, 1)) = 0
        _BlendAutoSpeed("Blend Auto Speed", float) = 0
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
                half2 uv_b : TEXCOORD2;
                half4 vertex : SV_POSITION;
            };

            sampler2D_half _MainTex, _BlendTex;
            half4 _MainTex_ST;
            half _BlendAlpha, _BlendPos, _BlendAutoSpeed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                if (_BlendAutoSpeed > 0) {
                    _BlendPos = cos(_Time.y * _BlendAutoSpeed) > 0 ? sin(_Time.y * _BlendAutoSpeed) : 1;
                }
                o.uv_b = half2(v.uv.x - _BlendPos, v.uv.y + _BlendPos);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 m = tex2D(_MainTex, i.uv);
                half4 b = tex2D(_BlendTex, i.uv_b);
                return half4(m.rgb + half3(b.rgb * b.w * _BlendAlpha).rgb, m.w);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}