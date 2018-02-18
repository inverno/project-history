var Git = require("nodegit");
var fs = require("fs");
var path = require("path");

// buildHistory("../SonarSource", "restbase");

// buildHistory("source_projects", "prettier");

// buildHistory("source_projects", "Dashboard");

// buildHistory("source_projects", "Ghost");

// buildHistory("source_projects", "vue");

buildHistory("source_projects", "keystone");

function buildHistory(basePath, projectName) {
  Git.Repository.open(path.join(basePath, projectName))
    .then(function(repo) {
      console.log("Repo...");
      return repo.getMasterCommit();
    })
    .then(function(firstCommitOnMaster) {    
      let history = firstCommitOnMaster.history();
      let projectFolder = path.join("history", projectName);
      history.on("commit", function(commit) {
        commit.getDiff().then(diffs =>
          diffs.forEach(diff => 
            diff.patches().then(patches =>
              patches.forEach(patch =>
                patch.hunks().then(hunks =>
                  hunks.forEach(hunk => {
                    const entryPath = patch.newFile().path();
                    commit.getEntry(entryPath).then(entry => {
                      if (
                        entry.isBlob() &&
                        entry.name().endsWith(".js") &&
                        !entryPath.includes("tests/") &&
                        !entry.name().includes(".min.") &&
                        !entry.name().includes("parser-parser5")) {
                          const commitFolder = path.join(projectFolder, "commits", commit.sha());
                          console.log(commitFolder);
                          ensureDirectoryExistence(commitFolder);
                          const filePath = path.join(commitFolder, entryPath);
                          ensureDirectoryExistence(filePath);
                          entry.getBlob().then(blob => fs.writeFileSync(filePath, blob));
                          const diffLine = filePath + "|" + hunk.newStart() + "\n";
                          fs.appendFileSync(path.join(projectFolder,"changes.csv"), diffLine);
                      }
                    }).catch(e => console.log(e))
                  })
                ).catch(e => console.log(e))
              )
            ).catch(e => console.log(e))
          )
        ).catch(e => console.log(e));
      });

      history.start();
    });
}

function ensureDirectoryExistence(filePath) {
  var dirname = path.dirname(filePath);
  if (fs.existsSync(dirname)) {
    return true;
  }
  ensureDirectoryExistence(dirname);
  fs.mkdirSync(dirname);
}
