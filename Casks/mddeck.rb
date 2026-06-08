cask "mddeck" do
  # `just release <v>` (run from the slantedt/markdowndeck repo) populates the
  # real values: it seds the `version "…"` line and the `sha256 "…"` line, then
  # uploads MarkdownDeck.zip as an asset of the matching `v<version>` GitHub
  # release. No release exists yet, so these are placeholders — `:no_check`
  # keeps this valid Ruby and obviously-not-real until the first release ships.
  #
  # NOTE: `just release` rewrites `sha256 "…"` via `sed`. When the first real
  # release is cut, replace `:no_check` below with a quoted placeholder
  # (`sha256 "0" * 64`-style or any `sha256 "…"`) so the sed pattern matches.
  version "0.0.0"
  sha256 :no_check

  url "https://github.com/slantedt/markdowndeck/releases/download/v#{version}/MarkdownDeck.zip"
  name "MarkdownDeck"
  desc "Markdown-to-presentation viewer with PDF export"
  homepage "https://github.com/slantedt/markdowndeck"

  depends_on macos: :sonoma

  app "MarkdownDeck.app"
  # The mddeck CLI is embedded inside the app bundle (see slantedt/markdowndeck
  # PR #8) so @executable_path/../Frameworks resolves to the bundled
  # MarkdownDeckKit.framework at runtime.
  binary "#{appdir}/MarkdownDeck.app/Contents/MacOS/mddeck"

  zap trash: "~/Library/Preferences/com.slantedt.markdowndeck.plist"
end
