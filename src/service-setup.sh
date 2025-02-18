PYTHON_DIR="/var/packages/python311/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/usr/bin:${PYTHON_DIR}:${PATH}"
TMP_DIR="${SYNOPKG_PKGDEST}/../../tmp"
PACKAGE="rr-manager"

service_postinst ()
{
    separator="===================================================="

    echo ${separator}
    install_python_virtualenv

    echo ${separator}
    install_python_wheels
    # /bin/sqlite3 /usr/syno/etc/esynoscheduler/esynoscheduler.db <${SYNOPKG_PKGDEST}/app/createsqlitedata.sql

    echo ${separator}
    echo "Install packages to the app/libs folder"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --target ${SYNOPKG_PKGDEST}/app/libs/ -r ${SYNOPKG_PKGDEST}/share/wheelhouse/requirements.txt

    echo ${separator}
     if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        echo "Populate config.txt"
        sed -i -e "s|@this_is_upload_realpath@|${wizard_download_dir}|g" \
            -e "s|@this_is_sharename@|${wizard_download_share}|g" \
            -e "s|@this_is_rr_tpm_dir@|${wizard_watch_dir}|g" \
        "${SYNOPKG_PKGDEST}/app/config.txt"
    fi
}

preupgrade ()
{
 # Save configuration files
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}

      # Save package config
    mv "${SYNOPKG_PKGDEST}/app/config.txt" ${TMP_DIR}/${PACKAGE}
}

postupgrade ()
{
    # Restore package config
    mv "${TMP_DIR}/${PACKAGE}/config.txt" "${SYNOPKG_PKGDEST}/app/config.txt"
}