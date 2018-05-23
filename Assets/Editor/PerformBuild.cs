using UnityEditor;
using UnityEngine;
using System.IO;
using System.Collections;
using System.Collections.Generic;

class PerformBuild
{
	private static string BUILD_LOCATION = "+buildlocation";

	static string GetBuildLocation(BuildTarget buildTarget)
	{
		string[] args = System.Environment.GetCommandLineArgs();
		int indexOfBuildLocation = System.Array.IndexOf(args, BUILD_LOCATION);
		if (indexOfBuildLocation >= 0)
  		{	
			indexOfBuildLocation++;
			Debug.Log(string.Format("Build Location for {0} set to {1}", buildTarget.ToString(), args[indexOfBuildLocation]));
			return args[indexOfBuildLocation];
 		}
		else 
		{
			Debug.Log(string.Format("Build Location for {0} not set. Defaulting to {1}",buildTarget.ToString(), 
			                        EditorUserBuildSettings.GetBuildLocation(buildTarget)));
			return EditorUserBuildSettings.GetBuildLocation(buildTarget);
		}
	}

	static string[] GetBuildScenes()
	{
		List<string> names = new List<string>();
		
		foreach(EditorBuildSettingsScene e in EditorBuildSettings.scenes)
		{
			if(e==null)
				continue;
			
			if(e.enabled)
				names.Add(e.path);
		}
		return names.ToArray();
	}

	static void BuildPlayerTarget(BuildTarget target){
		Debug.Log("Command line build " + target.ToString() + " version\n------------------\n------------------");

		string[] scenes = GetBuildScenes();
		string path = GetBuildLocation(target);
		if(scenes == null || scenes.Length==0 || path == null)
			return;

		Debug.Log(string.Format("Path: \"{0}\"", path));
		for(int i=0; i < scenes.Length; ++i)
		{
			Debug.Log(string.Format("Scene[{0}]: \"{1}\"", i, scenes[i]));
		}

		Debug.Log(string.Format("Creating Directory \"{0}\" if it does not exist", path));
		(new FileInfo(path)).Directory.Create();

		Debug.Log(string.Format("Switching Build Target to {0}", target.ToString()));
		BuildTargetGroup buildTargetGroup = BuildPipeline.GetBuildTargetGroup (target);
		EditorUserBuildSettings.SwitchActiveBuildTarget(buildTargetGroup, target);

		Debug.Log("Starting " + target.ToString() + " Build!");
		BuildPipeline.BuildPlayer(scenes, path, target, BuildOptions.None);

	}
	
	[UnityEditor.MenuItem("Perform Build/iOS Command Line Build")]
	static void CommandLineBuildiOS ()
	{
		BuildPlayerTarget(BuildTarget.iOS);
	}
	
	[UnityEditor.MenuItem("Perform Build/Android Command Line Build")]
	static void CommandLineBuildAndroid ()
	{
		BuildPlayerTarget(BuildTarget.Android);
	}

	[UnityEditor.MenuItem("Perform Build/WebGL Command Line Build")]
	static void CommandLineBuildWebGL ()
	{
		BuildPlayerTarget(BuildTarget.WebGL);
	}

	[UnityEditor.MenuItem("Perform Build/WebGL")]
	static void buildWebGL() {
		string[] scenes = {"Assets/MainLevel.unity"};
		string path = "Build/webgl";
		BuildPipeline.BuildPlayer(scenes, path, BuildTarget.WebGL, BuildOptions.None);
	}
		
}
