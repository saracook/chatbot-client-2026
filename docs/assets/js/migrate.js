// Autofill form from session storage
        window.addEventListener('DOMContentLoaded', function() {
            const storedSunetid = sessionStorage.getItem('sunetid');
            var sunetid = '<sunetid>';
            if(storedSunetid) {
                sunetid = storedSunetid;   
            }
            const storedLocalDirectory = sessionStorage.getItem('localDirectory');
            var localDirectory = '~/local_backup';
            if(storedLocalDirectory) {
                localDirectory = storedLocalDirectory;   
            }
            const storedDryRun = sessionStorage.getItem('dryRun') === 'true';

                document.getElementById('sunetid').value = sunetid;
                document.getElementById('localDirectory').value = localDirectory;
                document.getElementById('dryRun').checked = storedDryRun;
        });

        document.getElementById('rsyncForm').addEventListener('submit', function(event) {
            event.preventDefault();
            const localDirectory = document.getElementById('localDirectory').value;
            const sunetid = document.getElementById('sunetid').value;
            const dryRun = document.getElementById('dryRun').checked;
            // Store values in session storage
            sessionStorage.setItem('sunetid', sunetid);
            sessionStorage.setItem('localDirectory', localDirectory);
            sessionStorage.setItem('dryRun', dryRun);
            const dryRunFlag = dryRun ? '--dry-run' : '';

            const rsyncCmd = `rsync -avz ${dryRunFlag} ${sunetid}@login.carina.stanford.edu:/home/${sunetid}/  ${localDirectory}`;
            document.getElementById('rsyncCmd').value = rsyncCmd;

            const rsyncCmd2 = `rsync -avz ${dryRunFlag} ${localDirectory} ${sunetid}@login.carina.stanford.edu:/home/${sunetid}/  `;
            document.getElementById('rsyncCmd2').value = rsyncCmd;

        });

        document.getElementById('copyBtn').addEventListener('click', function() {
            const rsyncCmdInput = document.getElementById('rsyncCmd');
            rsyncCmdInput.select();
            rsyncCmdInput.setSelectionRange(0, 99999); // For mobile devices
            navigator.clipboard.writeText(rsyncCmdInput.value).then(() => {
                alert('Rsync command copied to clipboard!');
            }, () => {
                alert('Failed to copy rsync command to clipboard.');
            });
        });
