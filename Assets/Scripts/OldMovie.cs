using UnityEngine;
using System.Collections;

public class OldMovie : MonoBehaviour {

    public Shader m_Shader;
    public float m_OldEffectAmount = 1.0f;
    public Color m_Sephia = Color.white;
    public Texture2D m_Vignette;
    public float m_VignetteAmount = 1.0f;
    public Texture2D m_Scratches;
    public float m_ScratchesYSpeed = 10f;
    public float m_ScratchesXSpeed = 10f;
    public Texture2D m_Dust;
    public float m_DustYSpeed = 10f;
    public float m_DustXSpeed = 10f;
    float m_RandomValue;

    Material _Material;
    public Material Material 
    {
        get
        {
            if (_Material == null)
            {
                _Material = new Material(m_Shader);
            }
            return _Material;
        }
        
    }

    void Start() 
    {
        if (!SystemInfo.supportsImageEffects)
            enabled = false;

        if (!m_Shader && !m_Shader.isSupported)
            enabled = false;
    }

    void Update() 
    {
        m_VignetteAmount = Mathf.Clamp01(m_VignetteAmount);
        m_OldEffectAmount = Mathf.Clamp(m_OldEffectAmount, 0f, 1.5f);
        m_RandomValue = Random.Range(-1f,1f);
    }

    void OnRenderImage(RenderTexture source, RenderTexture dest) 
    {
        if (m_Shader != null) 
        {
            Material.SetColor("_SephiaColor", m_Sephia);
            Material.SetFloat("_VignetteAmount", m_VignetteAmount);
            Material.SetFloat("_OldEffectAmount", m_OldEffectAmount);

            if (m_Vignette)
                Material.SetTexture("_Vignette", m_Vignette);

            if (m_Scratches)
            {
                Material.SetTexture("_Scratches", m_Scratches);
                Material.SetFloat("_ScratchesXSpeed", m_ScratchesXSpeed);
                Material.SetFloat("_ScratchesYSpeed", m_ScratchesYSpeed);
            }

            if (m_Dust)
            {
                Material.SetTexture("_Dust", m_Dust);
                Material.SetFloat("_DustXSpeed", m_DustXSpeed);
                Material.SetFloat("_DustYSpeed", m_DustYSpeed);
                Material.SetFloat("_RandomValue", m_RandomValue);
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
