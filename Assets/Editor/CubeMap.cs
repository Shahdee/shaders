using UnityEngine;
using UnityEditor;
using System.Collections;

public class CubeMap : ScriptableWizard
{
    public Transform m_Transform;
    public Cubemap m_Cubemap;

    void OnWizardUpdate()
    {
        string helpString ="select Transform to render from a cubemap";

        if (m_Transform!=null & m_Cubemap!=null)
            isValid = true;
        else
            isValid = false;
    }

    void OnWizardCreate() 
    {
        GameObject obj = new GameObject("Cubecam", typeof(Camera));
        obj.transform.position = m_Transform.position;
        obj.transform.rotation = Quaternion.identity;

        obj.camera.RenderToCubemap(m_Cubemap);

        DestroyImmediate(obj);
    }

    [MenuItem("Di/Cubemap")]
    static void RenderCubemap() 
    {
        ScriptableWizard.DisplayWizard("Render cubemap", typeof(CubeMap), "Render!");
    }
}
