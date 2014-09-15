using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class FresnelSystem : MonoBehaviour {

    public Cubemap m_MapA;
    public Cubemap m_MapB;
    Cubemap m_MapCurr;

    public Transform m_Transform_A;
    public Transform m_Transform_B;
    Transform m_Tranform;

    Material m_CurrMaterial;

    void Awake() 
    {
        m_Tranform = transform;
    }

    void OnDrawGizmos() 
    {
        Gizmos.color = Color.green;

        if (m_Transform_A) 
        {
            Gizmos.DrawWireSphere(m_Transform_A.position, 0.5f);
        }

        if (m_Transform_B)
        {
            Gizmos.DrawWireSphere(m_Transform_B.position, 0.5f);
        }
    }

    Cubemap CheckDistance() 
    {
        float d1 = Vector3.Distance(m_Tranform.position, m_Transform_A.position);
        float d2 = Vector3.Distance(m_Tranform.position, m_Transform_B.position);

        if (d1 < d2)
            return m_MapA;
        else
        {
            if (d1 > d2)
                return m_MapB;
            else
                return m_MapA;
        }
    }

    void Update() 
    {
        m_CurrMaterial = renderer.sharedMaterial;
        if (m_CurrMaterial) 
        {
            m_MapCurr = CheckDistance();
            m_CurrMaterial.SetTexture("_Cubemap", m_MapCurr);
        }
    }
}
