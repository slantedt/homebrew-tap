cask "mddeck" do
  # `just release <v>` (run from the markdowndeck source repo) builds the signed
  # release, publishes MarkdownDeck.zip as the matching v<version> release on the
  # public dist repo slantedt/markdowndeck-dist, then sed-pins the two lines below.
  # They are placeholders until the first real release ships (the url 404s until
  # then), and are quoted (not :no_check) so the release recipe's anchored sed
  # substitutions match. (No literal version/sha example in this comment — an
  # unanchored sed would otherwise rewrite it.)
  version "0.1.0"
  sha256 "477da81bd10b103e966447ea13a3b32cdc8ef8cb2847dd47711a8d93a4569bc4"

  url "https://github.com/slantedt/markdowndeck-dist/releases/download/v#{version}/MarkdownDeck.zip"
  name "MarkdownDeck"
  desc "Markdown-to-presentation viewer with PDF export"
  homepage "https://github.com/slantedt/markdowndeck-dist"

  depends_on macos: :sonoma

  app "MarkdownDeck.app"
  # The mddeck CLI is embedded inside the app bundle (see slantedt/markdowndeck
  # PR #8) so @executable_path/../Frameworks resolves to the bundled
  # MarkdownDeckKit.framework at runtime.
  binary "#{appdir}/MarkdownDeck.app/Contents/MacOS/mddeck"

  zap trash: "~/Library/Preferences/com.slantedt.markdowndeck.plist"
end
