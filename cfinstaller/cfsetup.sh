if [ -z $1 ]
then
    echo "Usage: cfsetup.sh [target installation directory]"
    exit 1
fi
STARTDIR=$(pwd)
mkdir -p $1
cd $1
git clone https://github.com/ewels/clusterflow.git .
git checkout v0.4devel
git clone https://github.com/ewels/clusterflow-uppmax.git
mv clusterflow-uppmax/ scripts
cp ${STARTDIR}/clusterflow.config.uppmax ./clusterflow.config
echo -e "\n\n## Added by Cluster Flow installer\nexport PATH="'$PATH'":$(pwd)\nexport PATH="'$PATH'":$(pwd)/scripts" >> ~/.bashrc
./scripts/cf-uppmax --add_genome
./cf --setup
