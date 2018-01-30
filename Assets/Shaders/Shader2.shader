Shader "Custom/Shader2" 
{
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Scale ("Scale", float) = 1
        _Speed ("Speed", float) = 1
        _Frequency ("Frequency", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            float _Scale, _Speed, _Frequency;

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

            v2f vert (appdata v)
            {
                v2f o;
                half offsetvert = (v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z);
                half value = _Scale * sin(_Time.w * _Speed + offsetvert * _Frequency);
                v.vertex.y += value;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 c = tex2D(_MainTex, i.uv);
                return c;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}