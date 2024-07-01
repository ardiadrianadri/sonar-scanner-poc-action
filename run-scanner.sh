echo "Cleanning work directory"
if test -f "./package-lock.json"; then
    rm package-lock.json
fi

if test -f "./.npmrc"; then
    rm .npmrc
fi

echo "Installing dependencies"
npm i

echo "Running test"
npm run test

echo "Running scanner"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --workspace)
            WORKSPACE=$2
            shift
            shift
            ;;
        --token)
            TOKEN=$2
            shift
            shift
            ;;
        --host)
            HOST=$2
            shift
            shift
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

docker run -v $WORKSPACE:/usr/src -e SONAR_TOKEN=$TOKEN -e SONAR_HOST_URL=$HOST sonarsource/sonar-scanner-cli
