Shader "Custom/Shader1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Brightness("Brightness", float) = 1
        _Saturation("Saturation", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

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

            sampler2D _MainTex;
            half4 _MainTex_ST;
            half _Brightness, _Saturation;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            half4 frag (v2f i) : SV_Target
            {
                half4 color = tex2D(_MainTex, i.uv);
                half grayColorLuma = dot(color, half3(0.2126h, 0.7152h, 0.0722h)) * _Brightness;
                half4 grayColor = half4(grayColorLuma, grayColorLuma, grayColorLuma, color.a);
                half3 finalColorRgb = lerp(grayColor.rgb, color.rgb, _Saturation);
                half4 finalColor = half4(finalColorRgb, color.a);
                return grayColor;
            }
            ENDCG
        }
    }
}
