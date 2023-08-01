# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can't go back!**

If you aren't satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you're on your own.

You don't have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn't feel obligated to use this feature. However we understand that this tool wouldn't be useful if you couldn't customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: [https://facebook.github.io/create-react-app/docs/code-splitting](https://facebook.github.io/create-react-app/docs/code-splitting)

### Analyzing the Bundle Size

This section has moved here: [https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size](https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size)

### Making a Progressive Web App

This section has moved here: [https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app](https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app)

### Advanced Configuration

This section has moved here: [https://facebook.github.io/create-react-app/docs/advanced-configuration](https://facebook.github.io/create-react-app/docs/advanced-configuration)

### Deployment

This section has moved here: [https://facebook.github.io/create-react-app/docs/deployment](https://facebook.github.io/create-react-app/docs/deployment)

### `npm run build` fails to minify

This section has moved here: [https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify](https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify)

# Setup Deploy script

Automatic deployment with Google Cloud Platform (GCP)

0. Create GCP Project

1. **Create a Service Account on Google Cloud**:

   - Create Service Account key page (https://console.cloud.google.com/apis/credentials/serviceaccountkey).
   - From the Service account list, select New service account.
   - In the Service account name field, enter a name.
   - From the Role list, select Project > Owner.
   - Click Create. A JSON file that contains your key downloads to your local environment.
   - Note down the file path of this JSON file. This will be used in the GitHub Secrets.

2. **Store GCP Service Account Keys in GitHub Secrets**: GitHub Secrets enable you to store sensitive information, like the GCP service account keys, in your repository.

   - In your GitHub repository, navigate to the Settings tab, and then click on Secrets in the left sidebar.
   - Click on New repository secret button.
   - Name the secret something like `GCP_SA_KEY` and paste the entire contents of the service account key file (the JSON file you downloaded earlier) into the Value field.
   - Click Add secret to save it.

3. **Create a GitHub Actions Workflow**: In your repository, create a new file in the `.github/workflows` directory, for example `.github/workflows/deploy.yml`. In this file, you can define your deployment workflow. Here's an example:

```yaml
name: Deploy to Google Cloud Platform

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Setup Google Cloud SDK
        uses: google-github-actions/setup-gcloud@v0.2.1
        with:
          project_id: ${{ secrets.GCP_PROJECT_ID }}
          service_account_key: ${{ secrets.GCP_SA_KEY }}
          export_default_credentials: true

      - name: Deploy to GCP
        run: |
          gcloud compute instances update-container my-instance --zone us-central1-a --container-image gcr.io/my-project/my-image
```

In this example, replace `my-instance`, `us-central1-a`, `gcr.io/my-project/my-image` with your instance name, zone, and container image path.

This workflow is triggered whenever there's a `push` to the `main` branch. It sets up the Google Cloud SDK, authenticates using the secrets you added to the repository, and then runs the `gcloud compute instances update-container` command to update the container image.

Remember to replace `GCP_PROJECT_ID` with your Google Cloud Project ID and `GCP_SA_KEY` with the name of the GitHub secret containing your GCP service account key.

Also, keep in mind that the `deploy` step in the example above is very basic and may not suit your specific deployment needs. You may need to write additional scripts or commands to handle your particular use case.

4. **Push Workflow to GitHub**: Commit and push this new file to your repository. Now, whenever a commit is pushed to the `main` branch, this workflow will automatically run, deploying your code to GCP.

This is a basic example and your needs might be different based on your specific application and GCP service you are deploying to. You might want to adjust the workflow to include steps such as building your application, running tests, or more complex deployment scripts.

https://console.cloud.google.com/apis/api/compute.googleapis.com/overview?project=devt-394612

## Issues

ERROR: (gcloud.compute.instances.update-container) PERMISSION_DENIED: Compute Engine API has not been used in project 1012700770491 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=1012700770491 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.

Add Cloud Engine instance for frontend
gcloud compute instances create my-instance --zone=us-central1-a

ISSUE... fix incoming.

Log in to your Google Cloud account.
Navigate to Compute > Compute Engine > VM instances.
Click Create Instance.
Enter a name for the VM instance.
Select a Region.
Select the Zone.
Enter the following details under Machine configuration:
