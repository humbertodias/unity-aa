using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour {

	public GameObject pinPrefab;

	void Update ()
	{
        if (fire1())
		{
			SpawnPin();
		}
	}

	void SpawnPin ()
	{
		Instantiate(pinPrefab, transform.position, transform.rotation);
	}


    private bool fire1(){
        bool touch = (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began);
        bool click = Input.GetButtonDown("Fire1");
        return touch || click;
    }

}
