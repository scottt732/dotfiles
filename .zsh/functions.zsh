if command -v docker > /dev/null; then
    function dl () {
        docker logs --tail 1 --follow $1
    }

    function dr () {
        docker stop $1 && docker start $1
    }

    function drl () {
        docker stop $1 && docker start $1 && docker logs --tail 1 --follow $1
    }

    function dsrm () {
        docker stop $1 && docker rm $1
    }
fi
