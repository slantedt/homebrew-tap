cask "mddeck" do
  # `just release <v>` (run from the markdowndeck source repo) builds the signed
  # release, publishes MarkdownDeck.zip as the matching v<version> release on the
  # public dist repo slantedt/markdowndeck-dist, then sed-pins the two lines below.
  # They are placeholders until the first real release ships (the url 404s until
  # then), and are quoted (not :no_check) so the release recipe's anchored sed
  # substitutions match. (No literal version/sha example in this comment — an
  # unanchored sed would otherwise rewrite it.)
  version "0.1.1"
  sha256 "fd85756b5cf8c30a05580b9eba56a1b2a0403aa025ad34cb9a2d35ff6414dc12"

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
