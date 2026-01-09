// tour.js
document.addEventListener('DOMContentLoaded', function () {

    // Initialize intro.js
    var intro = introJs.tour();

    // Define the steps for the tour
    const steps = [];

    // Step configurations for main application sections
    const stepConfigs = [
        {
            title: 'Carina 2.0',
            intro: '<img src="/public/assets/images/tour-splash.png" alt="logo" class="py-2"><p>Take a tour of the new Carina OnDemand web interface</p>'
        },
        {
            element: '#pinned-apps',
            title: 'Popular Applications',
            intro: 'Launch your favorite apps on a compute node',
            position: 'right'
        },
        {
            element: '#pinned-apps .jupyter',
            title: 'JupyterLab',
            intro: 'An interactive development environment designed for data science, scientific computing, and machine learning workflows.',
            position: 'right'
        },
        {
            element: '#pinned-apps .matlab',
            title: 'MATLAB',
            intro: 'Advanced tools to implement and iterate on complex mathematical concepts and models',
            position: 'right'
        },
        {
            element: '#pinned-apps .rstudio',
            title: 'RStudio',
            intro: 'A development environment for R, a powerful programming language specifically designed for statistical analysis and data visualization',
            position: 'right'
        },
        {
            element: '#pinned-apps .desktop',
            title: 'Carina Desktop',
            intro: 'Launch the Carina virtual desktop, an Xfce server, on a compute node',
            position: 'right'
        },
        {
            element: '#pinned-apps .vscode',
            title: 'Virtual Studio Code',
            intro: 'Write, debug, track, and manage code directly on the cluster',
            position: 'right'
        },
        {
            element: '#pinned-apps .sas',
            title: 'SAS',
            intro: 'Conduct complex analyses of large datasets<p class="mt-3">SAS is available via the Carina desktop</p>',
            position: 'right'
        },
        {
            element: '.main-scaffold.col-md-4',
            title: 'Right Column',
            intro: 'The right column holds utilities, and lets you access your recent applications and active interactive sessions',
            position: 'left'
        },
        {
            element: '#recently-used-apps',
            title: 'Recently Used Apps',
            intro: 'Clicking on one of these will launch a session with the same specs as your last session',
            position: 'left'
        },
        {
            element: '.active-sessions',
            title: 'Active Sessions',
            intro: 'This section shows your running and queued interactive sessions',
            position: 'left'
        },
        {
            element: '.utility-list',
            title: 'Utilities',
            intro: 'These are utility links for managing files and jobs; these functions are also available in the navigation bar at the top of the page',
            position: 'left'
        },
        {
            element: '#list-files',
            title: 'File manager',
            intro: 'Access your personal and project files',
        },
        {
            element: '#list-job-manager',
            title: 'Job manager',
            intro: 'See your running SLURM jobs',
        },
        {
            element: '#list-job-composer',
            title: 'Job Composer',
            intro: 'Create new SLURM jobs from templates',
        },
        {
            element: '#list-shell',
            title: 'Shell',
            intro: 'Access a terminal on the compute node',
        },
        {
            element: '#list-system-status',
            title: 'System Status',
            intro: 'See how busy Carina is',
        },
        {
            element: '.navbar',
            title: 'Navigation Bar',
            intro: 'If you need it, it is probably here',
            position: 'bottom'
        }
    ];

    // Filter valid step configurations and add to steps
    stepConfigs.forEach(function (config) {
        if (config.element) {
            if (document.querySelector(config.element)) {
                steps.push(config);
            }
        } else {
            steps.push(config);
        }
    });

    // Additional steps for navigation menu items
    const navSteps = [
        {
            element: '[title="My Interactive Sessions"]',
            title: 'My Interactive Sessions',
            intro: 'See your current and past app sessions',
            position: 'left'
        },
        {
            element: '[title="Help"]',
            title: 'Help Menu',
            intro: 'Access help resources and submit support tickets from here.',
            position: 'top'
        },
    ];

    // Filter valid navigation steps and add to steps
    navSteps.forEach(function (navConfig) {
        if (document.querySelector(navConfig.element)) {
            steps.push(navConfig);
        }
    });

    // Check if there are steps available for tour
    if (steps.length > 0) {
        // Set options for the intro tour
        intro.setOptions({
            steps: steps,
            dontShowAgain: true,
            positionPrecedence: ["left", "right", "bottom", "top"],
            exitOnOverlayClick: true,
            showBullets: true,
            showProgress: false,
            nextLabel: 'Next',
            prevLabel: 'Back',
            doneLabel: 'Done',
            hidePrev: true
        });

        // Track the state of the currently opened dropdown
        let currentDropdown = null;

        function closeMenu() {
            $('.dropdown-toggle').removeClass('show');
            $('.dropdown-menu').removeClass('show');
        }

        // Event listeners for intro.js changes and exit
        intro.onbeforeexit(function () {
            closeMenu();
        });

        intro.onchange(function (targetElement) {
            // Close currently opened dropdown if any
            if (currentDropdown) {
                var currentToggle = currentDropdown.querySelector('.dropdown-toggle');
                if (currentToggle) {
                    currentToggle.classList.remove('show');
                }
                var currentMenu = currentDropdown.querySelector('.dropdown-menu');
                if (currentMenu) {
                    currentMenu.classList.remove('show');
                }
            }

            // Check if we're on a nav step
            if (targetElement && targetElement.attributes.title) {
                var title = targetElement.attributes.title.value;

                // Open dropdown if needed
                if (["Files", "Jobs", "Clusters", "Interactive Apps", "Develop", "Help"].includes(title)) {
                    var dropdown = targetElement.closest('.nav-item.dropdown');
                    if (dropdown) {
                        currentDropdown = dropdown; // Store the current dropdown
                        var dropdownToggle = dropdown.querySelector('.dropdown-toggle');
                        if (dropdownToggle) {
                            dropdownToggle.classList.add('show'); // Show the dropdown
                            var dropdownMenu = dropdown.querySelector('.dropdown-menu');
                            if (dropdownMenu) {
                                dropdownMenu.classList.add('show');
                            }
                        }
                    }
                }
            }
        });

        // Start the tour
        intro.start();
    } else {
        console.warn('No steps available for the tour. Ensure the necessary elements are present in the HTML.');
    }
});
