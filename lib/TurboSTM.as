/*
 Adapted from the Plugin_TurboSTM.as script shipped
 with Openplanet Turbo version 1.25.40 (2023-05-02)
*/

/*
 There have been reports that using the game's SuperSoloCampaign file
 would load the 2016-03-21_17_07 version, instead of the updated
 2016-09-29_18_08 version. As of May 4, 2023 I don't know if that's
 still an issue, but I have the infrastructure to load the file from
 the .op file itself, so I will continue using it.
*/
// #define USE_GAME_SOURCE

namespace TurboSTM
{
	class SuperTime
	{
		int m_number;
		uint m_time;
		string m_player;
	}

#if TURBO
	array<SuperTime@> g_superTimes;

	SuperTime@ GetSuperTime(int number)
	{
		for (uint i = 0; i < g_superTimes.Length; i++) {
			if (g_superTimes[i].m_number == number) {
				return g_superTimes[i];
			}
		}
		return null;
	}

#if USE_GAME_SOURCE
	CSystemFidFile@ GetFile(const string &in path)
	{
		for (int i = int(Fids::AllPacks.Length) - 1; i >= 0; i--) {
			auto pack = Fids::AllPacks[i];
			auto file = Fids::GetFidsFile(pack.Location, path);
			if (file !is null) {
				return file;
			}
		}
		return null;
	}
#endif

	void Initialize()
	{
#if USE_GAME_SOURCE
		while (Fids::AllPacks.Length != 2) {
			yield();
		}

		auto superSoloFile = GetFile("Media/Config/TMConsole/Campaign/SuperSoloCampaign.xml");
		if (Fids::Preload(superSoloFile) is null) {
			print("Unable to preload SuperSoloCampaign file!");
			return;
		}

		auto superSoloText = cast<CPlugFileText>(superSoloFile.Nod);
		if (superSoloText is null) {
			print("SuperSoloCampaign file is not a CPlugFileText file!");
			return;
		}

		auto superSoloDoc = XML::Document(superSoloText.Text);
#else
		// Use a pre-extracted version of the SuperSoloCampaign.xml, because the
		// game seems overly reluctant to load the right one. (This may be a bug
		// within the game, but I'm unsure so far.)
		IO::FileSource superSoloFile("lib/SuperSoloCampaign.xml");
		if (superSoloFile.Size() <= 0) {
			print("Unable to access SuperSoloCampaign file!");
			return;
		}

		auto superSoloDoc = XML::Document(superSoloFile.ReadToEnd());
#endif
		auto nodeRoot = superSoloDoc.Root();

		auto nodeTrackList = nodeRoot.Child("supersolocampaign");
		auto nodeTrack = nodeTrackList.FirstChild();
		while (nodeTrack) {
			auto newSuperTime = SuperTime();
			newSuperTime.m_number = Text::ParseInt(nodeTrack.Attribute("id")) + 1;
			newSuperTime.m_time = Text::ParseUInt(nodeTrack.Attribute("superauthortime"));
			newSuperTime.m_player = nodeTrack.Attribute("superplayer");
			g_superTimes.InsertLast(newSuperTime);

			nodeTrack = nodeTrack.NextSibling();
		}
	}
#else
	SuperTime@ GetSuperTime(int number) { return null; }
#if USE_GAME_SOURCE
	CSystemFidFile@ GetFile(const string &in path) { return null; }
#endif
	void Initialize() {}
#endif
}
