include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libQGLViewer-2.7.1)
vcpkg_download_distfile(ARCHIVE
    URLS "http://www.libqglviewer.com/src/libQGLViewer-2.7.1.zip"
    FILENAME "libQGLViewer-2.7.1.zip"
    SHA512 7175ecaa9965ae973befc1ddd7b4bc57fcb67ae5143e9291d4bca79309a3a62b2fa5f64d87f6ccedf7654cacc099f985b86db8326e79497008793780b546ad33
)
vcpkg_extract_source_archive(${ARCHIVE})

set(DEBUG_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg")
set(RELEASE_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel")

vcpkg_configure_qmake(SOURCE_PATH ${SOURCE_PATH}/QGLViewer)

vcpkg_build_qmake(
    RELEASE_TARGETS release
    DEBUG_TARGETS debug
)

#Set the correct install directory to packages
foreach(MAKEFILE ${RELEASE_MAKEFILES} ${DEBUG_MAKEFILES})
    vcpkg_replace_string(${MAKEFILE} "(INSTALL_ROOT)${INSTALLED_DIR_WITHOUT_DRIVE}" "(INSTALL_ROOT)${PACKAGES_DIR_WITHOUT_DRIVE}")
endforeach()

#Install the header files
file(GLOB HEADER_FILES ${SOURCE_PATH}/QGLViewer/*.h)
file(INSTALL ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/qglviewer)

#Install the module files
file(INSTALL
    ${SOURCE_PATH}/QGLViewer/QGLViewer2.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib
)

file(INSTALL
    ${SOURCE_PATH}/QGLViewer/QGLViewerd2.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    file(INSTALL
        ${SOURCE_PATH}/QGLViewer/QGLViewer2.dll
        DESTINATION ${CURRENT_PACKAGES_DIR}/bin
    )

    file(INSTALL
        ${SOURCE_PATH}/QGLViewer/QGLViewerd2.dll
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
    )
endif()

vcpkg_copy_pdbs()	

# Handle copyright
file(COPY ${SOURCE_PATH}/licence.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/qglviewer)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/qglviewer/licence.txt ${CURRENT_PACKAGES_DIR}/share/qglviewer/copyright)
