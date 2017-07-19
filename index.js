var Git = require("nodegit");
var fs = require("fs");
var path = require("path");

// Open the repository directory.
Git.Repository.open("tmp")
  // Open the master branch.
  .then(function(repo) {
    return repo.getMasterCommit();
  })
  // Display information about commits on master.
  .then(function(firstCommitOnMaster) {
    // Create a new history event emitter.
    var history = firstCommitOnMaster.history();

    // Listen for commit events from the history.
    history.on("commit", function(commit) {
     commit.getDiff().then(diffs =>
      diffs.forEach(diff => 
        diff.patches(patches =>
          patches.forEach(patch =>
            patch.hunks(hunks =>
              hunks.forEach(hunk =>
                commit.getEntry(hunk.newFile().path()).then(entry => {
                  if(entry.isBlob() && entry.name().endsWith(".ts")) {
                    const path = "history/" + commit.sha();
                    if(!fs.existsSync(path)) {
                      fs.mkdirSync(path);
                    }
                    fs.writeFileSync()
                  }
                })
              )
            )
          )
        )
      )
     );
    });

    // Start emitting events.
    history.start();
  });

function ensureDirectoryExistence(filePath) {
  var dirname = path.dirname(filePath);
  if (fs.existsSync(dirname)) {
    return true;
  }
  ensureDirectoryExistence(dirname);
  fs.mkdirSync(dirname);
}