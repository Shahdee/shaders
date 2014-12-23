using UnityEngine;
using System.Collections;

public class BSC_ImageEffect : MonoBehaviour {

    public Shader m_Shader;

    Material m_Material;
    Material Material 
    {
        get 
        {
            if (m_Material == null) 
            {
                m_Material = new Material(m_Shader);
                m_Material.hideFlags = HideFlags.HideAndDontSave;
            }
            return m_Material;
        }
    }

    [Range(0,1)]
    public float m_Bright = 0;
    [Range(0, 1)]
    public float m_Saturate = 0;
    [Range(0, 1)]
    public float m_Contrast = 0;

    void Start() 
    {
        if (!SystemInfo.supportsImageEffects)
            enabled = false;

        if (!m_Shader && !m_Shader.isSupported)
            enabled = false;
    }

    void Update() 
    {
        m_Bright = Mathf.Clamp(m_Bright, 0, 1);
        m_Saturate = Mathf.Clamp(m_Saturate, 0, 1);
        m_Contrast = Mathf.Clamp(m_Contrast, 0, 1);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) 
    {
        if (m_Shader != null) 
        {
            Material.SetFloat("_Bright", m_Bright);
            Material.SetFloat("_Saturate", m_Saturate);
            Material.SetFloat("_Contrast", m_Contrast);

            Graphics.Blit(source, destination, m_Material);
        }
        else
            Graphics.Blit(source, destination);
    }
}
