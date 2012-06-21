#! /bin/bash

# see for the right order here
boxes=(basebox setupbox productionbox testbox developmentbox stagebox cibox)
boxes_dir='boxes'


# set VAGRANT_LOG=DEBUG
# set VAGRANT_LOG=INFO
# set VAGRANT_LOG=
# export alias vboxes='./build_boxes.sh'

boxes_list() {
  echo_this="[boxes list]"
  echo "$echo_this boxes: ${boxes[@]}"
  echo "$echo_this To edit the list of boxes, please see line 3 in this file"
}

box_start() {
  if [ ! -n "$1" ]; then
    echo "Usage: box start <box>"
    boxes_list
    exit
  fi

  box="$1"
  echo_this="[box_start][$box]"

  echo "$echo_this Starting the Box"

  pushd $boxes_dir/$box >/dev/null
    vagrant up
  popd >/dev/null
}

box_status() {
  if [ ! -n "$1" ]; then
    echo "Usage: box status <box>"
    boxes_list
    exit
  fi

  box="$1"
  echo_this="[box_status][$box]"

  pushd $boxes_dir/$box >/dev/null

  echo "$echo_this vagrant status"
  vagrant status

  popd >/dev/null
}

boxes_status() {
  for box in ${boxes[@]}; do
    box_status $box
  done
}

box_destroy() {
  if [ ! -n "$1" ]; then
    echo "Usage: box destroy <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd $boxes_dir/$box >/dev/null
    vagrant destroy -f
  popd >/dev/null
}

boxes_destroy() {
  for box in ${boxes[@]}; do
    box_destroy $box
  done
}

box_stop() {
  if [ ! -n "$1" ]; then
    echo "Usage: box stop <box>"
    boxes_list
    exit
  fi

  box="$1"

  pushd $boxes_dir/$box >/dev/null
    vagrant halt
  popd >/dev/null
}


boxes_stop() {
  for box in ${boxes[@]}; do
    box_stop $box
  done
}

box_base_remove() {
  if [ ! -n "$1" ]; then
    echo "Usage: box base remove <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd $boxes_dir/$box >/dev/null
    vagrant box remove $box
  popd >/dev/null
}

boxes_base_remove() {
  for box in ${boxes[@]}; do
    box_base_remove $box
  done
}

boxes_base_list() {
  vagrant box list
}

box_package() {
  if [ ! -n "$1" ]; then
    echo "Usage: box package <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd $boxes_dir/$box >/dev/null
    vagrant package $box --output $box.box
  popd >/dev/null
}

box_provision() {
  box="$1"
  pushd $boxes_dir/$box >/dev/null
    vagrant provision
  popd >/dev/null
}

box_add() {
  if [ ! -n "$1" ]; then
    echo "Usage: box add <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd $boxes_dir/$box >/dev/null
    vagrant box add $box $box.box
  popd >/dev/null
}

box_remove_pack() {
  if [ ! -n "$1" ]; then
    echo "Usage: box remove_pack <box>"
    boxes_list
    exit
  fi

  box="$1"
  pushd $boxes_dir/$box >/dev/null
    rm -f $box.box
  popd >/dev/null
}


test_box_is_added() {
  box=$1
  echo_this="[test is added] "
  pushd $boxes_dir/$box >/dev/null
    if [ $(vagrant box list |grep $box|wc -l) -gt 0 ]; then
      echo "$echo_this box $box is already added."
      echo "$echo_this You can start building the next box or"
      echo "$echo_this you can destroy you work and build new :)."
    else
      echo "$echo_this box is not added"
    fi
  popd >/dev/null
}

# prüfen ob die box gepackt ist und die gepackte box
# an der richtigen stelle liegt
test_box_is_packed() {

  box=$1
  echo_this="[test is packed]"
  if [ -f $boxes_dir/${box}/$box.box ]
  then
    echo "$echo_this $boxes_dir/${box}/$box.box exists. (run 'box add $box')"
    #echo "yes"
  else
    echo "$echo_this $boxes_dir/${box}/$box.box is not packed. (run 'box build $box')"
    #echo "no"
  fi
}

box_build() {
  if [ ! -n "$1" ]; then
    echo "Usage: box build <box>"
    boxes_list
    exit
  fi

  echo_this="[box_build][$1]"

  # set $box
  match=$(echo "${boxes[@]:0}" | grep -o $1)
  if [ -z $match ]; then
    echo "$echo_this The box you chose '$1' is not existing. Please edit enabled boxes or check that the box you want to build exists"
    boxes_list
    exit
  fi

  box=$1

  # if running stop
  if [ $(box_status $box |grep running|wc -l) -gt 0 ]; then
    echo "$echo_this Halting the box"
    box_stop $box
  elif [ $(box_status $box |grep poweroff|wc -l) -gt 0 ]; then
    echo "$echo_this The $box is powered off"
  else
    box_status $box
  fi

  # destroy vm
  echo "$echo_this Destroying the box $box"
  box_destroy $box

  # remove from added boxes
  if [ $(vagrant box list |grep $box|wc -l) -gt 0 ]; then
    echo "$echo_this Removing the box $box from list of added boxes"
    box_base_remove $box
  fi

  if [ -f $boxes_dir/${box}/${box}.box ]; then
    echo "$echo_this file $boxes_dir/${box}/${box}.box exists, will be deleted."
    box_remove_pack $box
  else
    echo "$echo_this file $boxes_dir/${box}/${box}.box does not exist, proceeding."
  fi

  box_start $box

  echo -n "$echo_this Do you want to proceed? [Y/n] "
  read proceed_building_box

  if [ "$proceed_building_box" == "n" ]; then
    echo "$echo_this Stopping the build process of box $box"
    exit
  fi

  box_stop $box

  box_package $box

  box_add $box

}

boxes_build() {
  echo_this="[boxes build]"

  for box in ${boxes[@]}; do
    box_build $box

    test_box_is_packed $box
    test_box_is_added $box

    echo -n "$echo_this Do you want to proceed? [Y/n]"
    read proceed_building_boxes

    if [ "$proceed_building_boxes" == "n" ]; then
      echo "$echo_this Stopping the  build process"
      exit
    fi
  done
}


start() {

  case "$1" in
  'box')

    case "$2" in
    'build')
      box_build $3
      ;;
    'start')
      box_start $3
      ;;
    'stop')
      box_stop $3
      ;;
    'package')
      box_package $3
      ;;
    'add')
      box_start $3
      ;;
    'destroy')
      box_destroy $3
      ;;
    'remove_pack')
      box_remove_pack $3
      ;;
    'status')
      box_status $3
      ;;
    'provision')
      box_provision $3
      ;;
    'base')
      case "$3" in
      'remove')
        box_base_destroy $4
        ;;
      *)
        echo "Usage: box base <option>
Options:
  - remove    remove box from list of added boxes
"
        ;;
      esac
      ;;
    *)
      echo "Usage: box <option>
Options:
  - build <box>         build a box
  - start <box>         start a box
  - stop <box>          halt a box
  - package <box>       package a box
  - add <box>           add a box as basebox
  - destroy <box>       destroy created box
  - remove_pack <box>   removes packed file
  - status <box>        show status of box
  - provision <box>     provision a box
  - base                .. more options here
"
      ;;
    esac
    ;;
  'boxes')
    case "$2" in
    'build')
      boxes_build
      ;;
    'stop')
      boxes_stop
      ;;
    'destroy')
      boxes_destroy
      ;;
    'status')
      boxes_status
      ;;
    'list')
      boxes_list
      ;;
    'base')
      case "$3" in
      'remove')
        boxes_base_remove
        ;;
      'list')
        boxes_base_list
        ;;
      *)
        echo "Usage: boxes base <option>
  - remove   remove all added boxes
  - list     list all added boxes

"
        ;;
      esac
      ;;
    *)
    echo "Usage: boxes <option>
Options:
  - build    build all boxes
  - stop     halt all boxes
  - destroy  destroy all boxes
  - status   show status of all boxes
  - list     list all enabled boxes
  - base     .. more options here
"
      ;;
    esac
    ;;
  *)
    echo "Usage: <box|boxes> <options>"
    ;;
  esac
}

start $@