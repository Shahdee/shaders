using UnityEngine;
using System.Collections;

public class NightVision : MonoBehaviour {

    public Shader m_Shader;

    public float m_Contrast = 2.0f;
    public float m_Brightness = 1f;
    public Color m_NightVisColor = Color.white;
    public Texture m_Vignette;
    public Texture m_Stripes;
    public float m_StripesTileAmount = 4.0f;
    public Texture m_Noise;
    public float m_NoiseXSpeed = 100;
    public float m_NoiseYSpeed = 100;
    public float m_Distortion = 0.2f;
    public float m_Scale = 0.8f;

    float m_Random = 0f;

    Material _Material;
    public Material Material 
    {
        get 
        {
            if (_Material == null) 
                _Material = new Material(m_Shader);
            return _Material;
        }
    }
	
	void Start () {

        if (!SystemInfo.supportsImageEffects)
            enabled = false;

        if (!m_Shader && !m_Shader.isSupported)
            enabled = false;
	}
	
	
	void Update () {

        m_Contrast = Mathf.Clamp(m_Contrast, 0f, 4f);
        m_Brightness = Mathf.Clamp(m_Brightness, 0f, 2f);
        m_Random = Random.Range(-1f,1f);
        m_Distortion = Mathf.Clamp(m_Distortion, -1f, 1f);
        m_Scale = Mathf.Clamp(m_Scale, 0f,3f);

	}

    void OnRenderImage(RenderTexture source, RenderTexture dest) 
    {
        if (m_Shader != null)
        {
            Material.SetFloat("_Contrast", m_Contrast);
            Material.SetFloat("_Brightness", m_Brightness);
            Material.SetColor("_NightVisColor", m_NightVisColor);
            Material.SetFloat("_Random", m_Random);
            Material.SetFloat("_Distortion", m_Distortion);
            Material.SetFloat("_Scale", m_Scale);

            if (m_Vignette) 
            {
                Material.SetTexture("_Vignette", m_Vignette);
            }

            if (m_Stripes)
            {
                Material.SetTexture("_Stripes", m_Stripes);
                Material.SetFloat("_StripesTileAmount", m_StripesTileAmount);
            }

            if (m_Noise) 
            {
                Material.SetTexture("_Noise", m_Noise);
                Material.SetFloat("_NoiseXSpeed", m_NoiseXSpeed);
                Material.SetFloat("_NoiseySpeed", m_NoiseYSpeed);
            }
            Graphics.Blit(source, dest, Material);
        }
        else
            Graphics.Blit(source, dest, null);
    }

    void OnDestroy() 
    {
        if (Material != null)
            DestroyImmediate(Material);
    }
}
